# Imageer
Runs on [`localhost:4000`](http://localhost:4000) 

# upload endpoint 

http://localhost:4000/upload/<filename>

# uploading a file 

`curl -v -X POST  --header "Transfer-Encoding: chunked" --data-urlencode @/tmp/test.txt "http://localhost:4000/upload/foo"`

