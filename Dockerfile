FROM ubuntu

RUN apt-get update && apt-get install --yes runit

RUN mkdir /etc/service/my_service \
    && /bin/bash -c "echo -e '"'#!/bin/bash\nexec /my_service/my_service\n'"' > /etc/service/my_service/run" \
    && chmod +x /etc/service/my_service/run
RUN ln -s /usr/bin/sv /etc/init.d/my_service

WORKDIR /my_service

COPY my_service .

CMD ["runsvdir", "/etc/service"]
