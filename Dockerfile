FROM rust:1.78 AS builder
# 
ARG ARCH=x86_64
ENV DEBIAN_FRONTEND=noninteractive
# needed for distroless
ENV RUSTFLAGS='-C target-feature=+crt-static'
WORKDIR /kaspa

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    protobuf-compiler \
    libclang-dev 
COPY . . 
RUN cargo build --release --bin kaspad --target ${ARCH}-unknown-linux-gnu && mv target/${ARCH}-unknown-linux-gnu/release/kaspad /kaspad

FROM gcr.io/distroless/static-debian12
COPY --from=builder /kaspad /

ENTRYPOINT [ "/kaspad" ]
