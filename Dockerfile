FROM bitwalker/alpine-elixir:1.5
RUN apk --no-cache --update upgrade && \
  apk add --no-cache build-base curl automake autoconf libtool git zlib-dev

ENV GRPC_VERSION=1.16.0 \
        PROTOBUF_VERSION=3.6.1 \
        OUTDIR=/out

RUN mkdir -p /protobuf && \
        curl -L https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | tar xvz --strip-components=1 -C /protobuf


RUN cd /protobuf && \
      autoreconf -f -i -Wall,no-obsolete && \
      ./configure --prefix=/usr --enable-static=no && \
      make -j2 && make install

RUN cd /protobuf && \
        make install DESTDIR=${OUTDIR}

RUN find ${OUTDIR} -name "*.a" -delete -or -name "*.la" -delete

RUN apk add --no-cache curl && \
        mkdir -p /protobuf/google/protobuf && \
        for f in any duration descriptor empty struct timestamp wrappers; do \
        curl -L -o /protobuf/google/protobuf/${f}.proto https://raw.githubusercontent.com/google/protobuf/master/src/google/protobuf/${f}.proto; \
        done && \
        mkdir -p /protobuf/google/api && \
        for f in annotations http; do \
        curl -L -o /protobuf/google/api/${f}.proto https://raw.githubusercontent.com/grpc-ecosystem/grpc-gateway/master/third_party/googleapis/google/api/${f}.proto; \
        done && \
        mkdir -p /protobuf/github.com/gogo/protobuf/gogoproto && \
        curl -L -o /protobuf/github.com/gogo/protobuf/gogoproto/gogo.proto https://raw.githubusercontent.com/gogo/protobuf/master/gogoproto/gogo.proto && \
        mkdir -p /protobuf/github.com/mwitkow/go-proto-validators && \
        curl -L -o /protobuf/github.com/mwitkow/go-proto-validators/validator.proto https://raw.githubusercontent.com/mwitkow/go-proto-validators/master/validator.proto && \
        mkdir -p /protobuf/github.com/lyft/protoc-gen-validate/gogoproto && \
        mkdir -p /protobuf/github.com/lyft/protoc-gen-validate/validate && \
        curl -L -o /protobuf/github.com/lyft/protoc-gen-validate/gogoproto/gogo.proto https://raw.githubusercontent.com/lyft/protoc-gen-validate/master/gogoproto/gogo.proto && \
        curl -L -o /protobuf/github.com/lyft/protoc-gen-validate/validate/validate.proto https://raw.githubusercontent.com/lyft/protoc-gen-validate/master/validate/validate.proto && \
        apk del curl && \
        chmod a+x /usr/bin/protoc

RUN mix escript.install hex protobuf

ENV PATH=${PATH}:/usr/local/bin/protoc-gen-elixir

COPY . /app
WORKDIR /app
COPY ./run.sh /
RUN chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]
