defmodule Imageer.Chunker do
  use GenStateMachine
  import Logger

  defmodule State do
    import Logger

    @enforce_keys [:id, :chunk_size]
    defstruct [:id, :chunk_size, callback: &State.example_callback/2, acc: "", counter: 0]

    def example_callback(data, %State{acc: acc} = state) when is_binary(acc) do
      msg = ~s"""
      -dumping-
      id        : #{inspect(state.id)}
      counter   : #{state.counter}
      chunk_size: #{state.chunk_size}
      data      : #{inspect(data)}
      """
      debug(msg)
    end
  end

  def create(id, chunk_size) do
    {:ok, pid} =
      GenStateMachine.start_link(
        Imageer.Chunker,
        {:s_default, %State{id: id, chunk_size: chunk_size}}
      )

    pid
  end

  def create(id, chunk_size, callback) do
    {:ok, pid} =
      GenStateMachine.start_link(
        Imageer.Chunker,
        {:s_default, %State{id: id, chunk_size: chunk_size, callback: callback}}
      )

    pid
  end

  def get_state(pid) do
    :sys.get_state(pid)
  end

  def send_data(pid, data = <<_::binary>>) do
    GenStateMachine.cast(pid, {:input, data})
  end

  # # Callbacks

  def handle_event(
        :cast,
        {:input, data},
        :s_default,
        state = %State{
          chunk_size: chunk_size
        }
      ) do
    chunk = state.acc <> data



    case chunk do
      <<ready::binary-size(chunk_size), rest::binary>> ->
        debug("full - callback")
        state.callback.(ready, state)

        new_state =
          state
          |> Map.put(:acc, rest)
          |> Map.update(:counter, 0, &(&1 + 1))

        {:next_state, :s_default, new_state}

      _ ->
        debug("accumulate")

        new_state =
          state
          |> Map.put(:acc, chunk)
          |> Map.update(:counter, 0, &(&1 + 1))

        {:next_state, :s_default, new_state}
    end
  end
end
