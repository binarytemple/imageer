
defmodule Foo do
  # require Record
  # import Record, only: [defrecord: 2, extract: 2]

  # defrecord :aws_config, extract(:aws_config, from_lib: "erlcloud/include/erlcloud_aws.hrl")
end

defmodule LeveledKv do

  # defmodule State do
  #   defstruct :state, :base_path
  # end

end
# -include_lib("leveled/include/leveled.hrl").

# -record(state, {bookie, base_path}).

# new(Opts=#{path := Path}) ->
#     LedgerCacheSize = maps:get(ledger_cache_size, Opts, 2000),
#     JournalSize = maps:get(journal_size, Opts, 500000000),
#     SyncStrategy = maps:get(sync_strategy, Opts, none),
#     {ok, Bookie} = leveled_bookie:book_start(Path, LedgerCacheSize,
#                                              JournalSize, SyncStrategy),
#     State = #state{bookie=Bookie, base_path=Path},
#     {ok, State}.

# put(State=#state{bookie=Bookie}, Bucket, Key, Value) ->
#     R = leveled_bookie:book_put(Bookie, Bucket, Key, Value, []),
#     {R, State}.

# get(State=#state{bookie=Bookie}, Bucket, Key) ->
#     K = {Bucket, Key},
#     Res = case leveled_bookie:book_get(Bookie, Bucket, Key) of
#               not_found -> {not_found, K};
#               {ok, Value} -> {found, {K, Value}}
#           end,
#     {Res, State}.

# delete(State=#state{bookie=Bookie}, Bucket, Key) ->
#     R = leveled_bookie:book_delete(Bookie, Bucket, Key, []),
#     {R, State}.

# keys(State=#state{bookie=Bookie}, Bucket) ->
#     FoldHeadsFun = fun(_B, K, _ProxyV, Acc) -> [K | Acc] end,
#     {async, FoldFn} = leveled_bookie:book_returnfolder(Bookie,
#                             {foldheads_bybucket,
#                                 ?STD_TAG,
#                                 Bucket,
#                                 all,
#                                 FoldHeadsFun,
#                                 true, true, false}),
#     Keys = FoldFn(),
#     {Keys, State}.

# is_empty(State=#state{bookie=Bookie}) ->
#     FoldBucketsFun = fun(B, Acc) -> [B | Acc] end,
#     {async, FoldFn} = leveled_bookie:book_returnfolder(Bookie,
#                                                        {binary_bucketlist,
#                                                         ?STD_TAG,
#                                                         {FoldBucketsFun, []}}),
#     IsEmpty = case FoldFn() of
#                   [] -> true;
#                   _ -> false
#               end,
#     {IsEmpty, State}.

# close(State=#state{bookie=Bookie}) ->
#     R = leveled_bookie:book_close(Bookie),
#     {R, State}.

# delete(State=#state{base_path=Path}) ->
#     R = remove_path(Path),
#     {R, State}.


# foldl(Fun, Acc0, State=#state{bookie=Bookie}) ->
#     FoldObjectsFun = fun(B, K, V, Acc) -> Fun({{B, K}, V}, Acc) end,
#     {async, FoldFn} = leveled_bookie:book_returnfolder(Bookie, {foldobjects_allkeys,
#                                                                 ?STD_TAG,
#                                                                 {FoldObjectsFun, Acc0},
#                                                                 true}),
#     AccOut = FoldFn(),
#     {AccOut, State}.

# % private functions

# sub_files(From) ->
#     {ok, SubFiles} = file:list_dir(From),
#     [filename:join(From, SubFile) || SubFile <- SubFiles].

# remove_path(Path) ->
#     case filelib:is_dir(Path) of
#         false ->
#             file:delete(Path);
#         true ->
#             lists:foreach(fun(ChildPath) -> remove_path(ChildPath) end,
#                           sub_files(Path)),
#             file:del_dir(Path)
#     end.
