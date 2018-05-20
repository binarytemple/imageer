# Imageer

Runs on [`localhost:4000`](http://localhost:4000) 

# upload endpoint 

=======


To start your Phoenix app:

http://localhost:4000/upload/<filename>

# uploading a file 

`curl -v -X POST  --header "Transfer-Encoding: chunked" --data-urlencode @/tmp/test.txt "http://localhost:4000/upload/foo"`

## Testing using curl 

Add this handy url encoding helper to your dotfile

```
alias urlquote='python -c '\''import sys; import urllib ; print urllib.quote_plus(sys.argv[1])'\'
```

Perform an upload using curl

``` 
curl -v -X POST  -d @/tmp/test.txt "http://localhost:4000/upload/$( urlquote /tmp/test.txt)"
```

Or a chunked upload : 

```
curl -v -X POST  --header "Transfer-Encoding: chunked" \
    --data-binary @/tmp/test.txt "http://localhost:4000/upload/$( urlquote 'raw.txt')"
```
