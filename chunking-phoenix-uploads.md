
Sometimes phoenix/cowboy uploads are too big and you don't want to store them to the disk. 

Sometimes you have to process an incoming stream of data which is chunked to some arbitrary size, but you need to send it something else in another size.

Also, you don't want to buffer the whole request in memory as Erlang doesn't like sending large 
messages between processes.

Lets show it in action first, then take a look at the implementation.

First we set a convenience alias : 

```
alias Imageer.Chunker
```

Then we set the terminal process `:trap_exit` flag to true:

```
Process.flag(:trap_exit,true)
```

We create the chunker with a id of "foo/bar/baz/blah.txt" (perhaps it's being used to chunk a file) and a chunk size of 16 bytes: 

```
iex(210)> p=Chunker.create("foo/bar/baz/blah.txt",16,&Chunker.State.example_callback/2)       
#PID<0.910.0>
```

We send a greater amount of data than can be held in the buffer and observe the result

```
iex(213)> Chunker.send_data(p,"this will make you overflow")
:ok
[debug] -dumping-
id        : "foo/bar/baz/blah.txt"
counter   : 1
chunk_size: 16
data      : "this will make y"
acc_size  : 11
acc       : "ou overflow"
```

Looking above, we can see that the data is "this will make y" and the the accumulator is "ou overflow". Working correctly.

Now we feed the Chunker a single character of data 

```
iex(216)> Chunker.send_data(p,"!")                          
:ok
```

That's correct, no overflow, so the callback hasn't been invoked. 

Lets overflow the buffer by a multiple of the chunk size 

```
iex(217)> Chunker.send_data(p,"lots and lots and lots and lots and lots and lots of data")           
[debug] -dumping-
id        : "foo/bar/baz/blah.txt"
counter   : 3
chunk_size: 16
data      : "ou overflow!lots"
acc_size  : 53
acc       : " and lots and lots and lots and lots and lots of data"

:ok
[debug] -dumping-
id        : "foo/bar/baz/blah.txt"
counter   : 4
chunk_size: 16
data      : " and lots and lo"
acc_size  : 37
acc       : "ts and lots and lots and lots of data"

[debug] -dumping-
id        : "foo/bar/baz/blah.txt"
counter   : 5
chunk_size: 16
data      : "ts and lots and "
acc_size  : 21
acc       : "lots and lots of data"

[debug] -dumping-
id        : "foo/bar/baz/blah.txt"
counter   : 6
chunk_size: 16
data      : "lots and lots of"
acc_size  : 5
acc       : " data"

```

That was an async (cast) invocation btw, the Chunker is configured to put events on it's own event queue which will be handled before events received from other processes, so despite the fact that everything is asynchronous, this is perfectly safe.


Finally, when you are done adding data, you call `Chunker.flush_and_terminate/1`, any remaining data will be sent to the callback function and the process will terminate. 

```
iex(220)> Chunker.flush_and_terminate p 
[debug] -dumping-
id        : "foo/bar/baz/blah.txt"
counter   : 6
chunk_size: 16
data      : " data"
acc_size  : 5
acc       : " data"

:ok
```

Lets look at the implementation

```elixir

```
