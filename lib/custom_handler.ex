defmodule Imageer.CustomHandler do
  import Logger

  def init(_type, req, []) do
    {:ok, req, :no_state}
end

def handle(request, state) do
  { :ok, reply } = :cowboy_req.reply(

    # status code
    200,

    # headers
    [ {"content-type", "text/html"} ],

    # body of reply.
    "hello world",

    # original request
    request
)
{:ok, reply, state}
end

  # def handle(req, state) do
  #   Logger.warn(req, state)
  #    x  = :cowboy_req.reply(200, [ {"content-type", "text/plain"} ], "Hello world!", req)
  #   # warn(x)

  #   #  {:ok, req2} = x
  #   {:ok, req, state}
  # end

  def terminate(_Reason, _Req, _State) do
    Logger.warn("terminate")
    :ok
  end
end

# stream_body(Req0, Acc) ->
#  case cowboy_req:read_part_body(Req0) of
#      {more, Data, Req} ->
#          stream_body(Req, << Acc/binary, Data/binary >>);
#      {ok, Data, Req} ->
#          {ok, << Acc/binary, Data/binary >>, Req}
#  end.
