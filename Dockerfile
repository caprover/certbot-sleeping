FROM certbot/certbot:${CERTBOT_VERSION}
ENTRYPOINT ["/bin/sh","-c"]
CMD ["sleep 9999d"]
