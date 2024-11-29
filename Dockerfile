FROM alpine:3.19 AS build
ARG ALPINE_VERSION=3.19

USER root
WORKDIR /root

RUN apk add alpine-sdk git

RUN addgroup -S gaborcsardi && \
    adduser -S gaborcsardi -G gaborcsardi -u 1000 && \
    addgroup gaborcsardi abuild

RUN mkdir -p /home/gaborcsardi/.abuild
COPY gaborcsardi-673e2275.rsa.pub /home/gaborcsardi/.abuild/
COPY gaborcsardi-673e2275.rsa.pub /etc/apk/keys/
RUN echo 'PACKAGER_PRIVKEY="/home/gaborcsardi/.abuild/gaborcsardi-673e2275.rsa"' \
      >> /home/gaborcsardi/.abuild/abuild.conf && \
    ln -s /run/secrets/ABUILD_KEY \
      /home/gaborcsardi/.abuild/gaborcsardi-673e2275.rsa && \
    chown -R gaborcsardi /home/gaborcsardi/.abuild && \
    chgrp -R gaborcsardi /home/gaborcsardi/.abuild

USER gaborcsardi
WORKDIR /home/gaborcsardi

RUN git clone --depth 1 -b 3.19-stable \
    https://gitlab.alpinelinux.org/alpine/aports

COPY figlet.patch /home/gaborcsardi/aports/community/figlet/
RUN --mount=type=secret,id=ABUILD_KEY,uid=1000 \
    cd /home/gaborcsardi/aports/community/figlet/ && \
    patch < figlet.patch && \
    abuild -r

USER root
RUN apk add /home/gaborcsardi/packages/community/$(arch)/figlet*.apk
RUN cd /usr/local/bin && rm -f chkfont showfigfonts figlist

RUN echo 'figlet -f mini -- --------------------------------' \
    > /usr/local/bin/----- && \
    ln -s figlet /usr/local/bin/--

CMD [ "sh", "-c", "cp -r /home/gaborcsardi/packages/community/* /output/" ]

# -------------------------------------------------------------------------

FROM scratch AS figlet
COPY --from=build /usr/local /usr/local

ENV PATH=/usr/local/bin
WORKDIR /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/figlet" ]

LABEL org.opencontainers.image.source="https://github.com/gaborcsardi/figlet"
LABEL org.opencontainers.image.description="figlet in a container"
LABEL org.opencontainers.image.authors="https://github.com/gaborcsardi"
