FROM golang:1.16-alpine AS build

WORKDIR /go/src/GoApp

COPY GoApp .

RUN CGO_ENABLED=0 go build -o /go/bin/GoApp main.go

FROM scratch

COPY --from=build /go/bin/GoApp /go/bin/GoApp

EXPOSE 8080

ENTRYPOINT ["/go/bin/GoApp"]