# FROM ubuntu
FROM alpine

# RUN apt-get update && apt-get install --yes runit
RUN apk update && apk add runit

RUN mkdir /etc/service/my_service \
    && /bin/sh -c "echo -e '"'#!/bin/sh\nexec /my_service/my_service\n'"' > /etc/service/my_service/run" \
    && chmod +x /etc/service/my_service/run
RUN mkdir -vp /etc/init.d/ && ln -s /usr/bin/sv /etc/init.d/my_service

WORKDIR /my_service

COPY my_service .

CMD ["runsvdir", "/etc/service"]
