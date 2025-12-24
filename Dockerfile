FROM --platform=$BUILDPLATFORM golang:alpine AS build

COPY . /robertoTelegram
WORKDIR /robertoTelegram

ARG TARGETOS
ARG TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go mod download
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o robertoTelegram

FROM alpine

RUN apk add --no-cache ca-certificates ffmpeg gcompat

COPY --from=build /robertoTelegram/robertoTelegram /usr/bin/
COPY --from=thetipo01/dca /usr/bin/dca /usr/bin/

CMD ["robertoTelegram"]