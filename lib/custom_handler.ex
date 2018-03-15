defmodule Imageer.CustomHandler do
  import Logger

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end


  @read_length 512
  @load_length 512

  @request_args [
    {:length, @load_length},
    {:read_length, @read_length}
  ]

  def handle(request, state) do
    warn("cowboy_req.has_body(request) #{:cowboy_req.has_body(request)}")

    if :cowboy_req.has_body(request) do
      # file=stream_body(request, "")
      # info("file contents \n#{inspect(file)}")

      

      x= gen_stream(request) |> Enum.to_list

      warn("result = #{inspect(x)}")
      # {_,x1,r1} = :cowboy_req.body(request,@request_args)
      # warn("one: #{inspect(x1)}")
      # {_,x2,r2} = :cowboy_req.body(request,@request_args)
      # warn("two: #{inspect(x2)}")
    end

    # warn("#{inspect(:cowboy_req.headers(request))}")

    warn("got this far")

    {:ok, resp} =
      :cowboy_req.reply(200, [{"content-type", "text/plain"}], "Hello world!", request)

    {:ok, resp, state}
  end

  def terminate(_Reason, _Req, _State) do
    Logger.warn("terminating")
    :ok
  end


  def stream_body(req0, acc, chunk_args \\ @request_args
  ) do
    warn("entering into :  stream_body(req0, ")
    case :cowboy_req.body(req0,  chunk_args) do
      {:ok,data, req} ->
        warn("entering into :  ok - size : #{:erlang.size(data)}"  )
        {:ok, <<acc::bitstring,data::bitstring >> ,  req}
      {:more, data, req} ->
        warn("entering into :  more - size : #{:erlang.size(data)}")
          stream_body(req, <<acc::bitstring,data::bitstring >>    )
      {:error, reason} ->
        error(reason)
        {:ok, "final", req0}
    end
  end

  def gen_stream(request) do
        Stream.resource(
          fn -> request end,
          fn request ->
            case :cowboy_req.body(request,
            [
              {:length, @load_length},
              {:read_length, @read_length}
            ]
            ) do

              {:ok, "", request} ->
                warn("entering into :  zero ")
                 {:halt, request}

              {:ok, data, request} when is_binary(data)->
               warn("entering into :  ok - size : #{:erlang.size(data)}")
                {[data], request}


              {:more, data, request} ->
                # warn("entering into :  more - size : #{:erlang.size(data)}")
                # warn("entering into :  more - data : #{inspect(data)}")
                {[data], request}

              x ->
                warn("got x #{inspect(x)}")
                {:halt, request}
            end
          end,
          fn _ -> nil end
        )
      end

end
