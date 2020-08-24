FROM certbot/certbot:${ORIGINAL_TAG}-${CERTBOT_VERSION}
ENTRYPOINT ["/bin/sh","-c"]
CMD ["sleep 1999d"]
