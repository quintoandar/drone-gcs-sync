FROM google/cloud-sdk:alpine
RUN apk add --no-cache bash
ADD entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT [ "bash", "/usr/bin/entrypoint.sh" ]
