FROM golang:1.18 AS builder
ENV BLDDIR "/opt/gm2md/"
RUN mkdir ${BLDDIR}
COPY go.mod go.sum ${BLDDIR}
RUN cd ${BLDDIR} && go mod download && go mod verify
COPY . ${BLDDIR}
RUN cd ${BLDDIR} && go build -v -o /usr/local/bin/gm2md ./...

# final stage
FROM debian:11-slim
COPY --from=builder /usr/local/bin/gm2md /bin/gm2md

ENTRYPOINT ["/bin/gm2md", "-dir", "/github/workspace/gemtext"]

