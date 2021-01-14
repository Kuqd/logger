FROM golang as builder

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o logger main.go

# final stage
FROM alpine
COPY --from=builder /app/logger /app/
EXPOSE 8080
ENTRYPOINT ["/app/logger"]
