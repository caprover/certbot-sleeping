FROM certbot/certbot:${CERTBOT_ARCH}-${CERTBOT_VERSION}
ENTRYPOINT ['/bin/sh','-c' ]
CMD ['sleep 9999d']
