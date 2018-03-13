defmodule Imageer.CustomHandler do
  import Logger

  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    warn("cowboy_req.has_body(request) #{:cowboy_req.has_body(request)}")

    if :cowboy_req.has_body(request) do
      file=stream_body(request, "")
      info("file contents \n#{inspect(file)}")
    end

    warn("#{inspect(:cowboy_req.headers(request))}")

    warn("got this far")

    {:ok, resp} =
      :cowboy_req.reply(200, [{"content-type", "text/plain"}], "Hello world!", request)

    {:ok, resp, state}
  end

  def terminate(_Reason, _Req, _State) do
    Logger.warn("terminating")
    :ok
  end

  @chunk 8
  @read_length 1024 * @chunk
  @load_length 1024 * @chunk

  def stream_body(req0, acc) do
    warn("entering into :  stream_body(req0, ")
    case :cowboy_req.body(req0, [
        { :length, @load_length},
        { :read_length, @read_length}
      ] ) do
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
end
