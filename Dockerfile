FROM docker:19.03.13

RUN apk add --no-cache\
    python3 \
    curl \
    jq \
    groff; \
    set -ex; \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && pip install awscli
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
