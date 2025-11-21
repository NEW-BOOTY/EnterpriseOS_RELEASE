# syntax=docker/dockerfile:1
FROM alpine:3.20
LABEL maintainer="Devin B. Royal"
WORKDIR /app
COPY . /app
RUN adduser -D runner && chown -R runner:runner /app
USER runner
ENTRYPOINT ["/bin/sh","-lc","echo Container ready; ls -la"]
