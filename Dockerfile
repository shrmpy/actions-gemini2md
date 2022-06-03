FROM golang:1.18 AS builder
ENV BLDDIR "/opt/g2md/"
RUN mkdir ${BLDDIR}
COPY go.mod go.sum ${BLDDIR}
RUN cd ${BLDDIR} && go mod download && go mod verify
COPY . ${BLDDIR}
RUN cd ${BLDDIR} && go build -v -o /usr/local/bin/g2md ./...

# final stage
FROM scratch
COPY --from=builder /usr/local/bin/g2md /bin/gemini2md

ENTRYPOINT ["/bin/gemini2md", "-dir", "/github/workspace/gemtext"]
