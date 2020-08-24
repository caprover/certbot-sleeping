# certbot-sleeping
Extended certbot image that does not exit
```
ENTRYPOINT ['/bin/sh','-c' ]
CMD ['sleep 9999d']
```