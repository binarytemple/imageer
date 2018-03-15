defmodule Imageer do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      # supervisor(Imageer.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Imageer.Endpoint, [])
      # Start your own worker by calling: Imageer.Worker.start_link(arg1, arg2, arg3)
      # worker(Imageer.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Imageer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Imageer.Endpoint.config_change(changed, removed)
    :ok
  end

end

defmodule Imager.Util do
  import Logger

  def acumulator(payload, accumulator, size ) do

    chunk = payload  <> accumulator
    case chunk do
      << ready :: binary-size(size), rest:: binary >> ->
      debug("full")
        [:full,ready,rest]
      _ ->
        debug("accumulate")
        [:acc, chunk]
      end

    end


  end


  defmodule Switch do
    use GenStateMachine
    import Logger
    @binary_size 16

    def new(chunk_callback) when is_function(chunk_callback, 1) do
      {:ok,pid} = GenStateMachine.start_link(Switch, {:s_default, ["",0,chunk_callback]})
      pid
    end

    def state(pid) do
      :sys.get_state(pid)
    end

    def send_data(pid,data = <<_::binary>> ) do
      GenStateMachine.cast(pid, {:input, data})
    end
    # Callbacks

    def handle_event(:cast, {:input, data}, :s_default, [s_data,s_counter,chunk_callback]) do
      chunk = s_data <> data
      case chunk do
        << ready :: binary-size(@binary_size), rest:: binary >> ->
          debug("full - callback")
          chunk_callback.(ready)
          {:next_state, :s_default,
          [rest,s_counter + 1 ,chunk_callback]
        }
        _ ->
          debug("accumulate")
          {:next_state, :s_default,
          [chunk,s_counter + 1 ,chunk_callback]
          }
        end
    end

# v    def handle_event(:cast, :flip, :s_default, data) do
#       {:next_state, :off, data}
#     end

    # def handle_event({:call, from}, :get_count, state, data) do
    #   {:next_state, state, data, [{:reply, from, data}]}
    # end
  end
