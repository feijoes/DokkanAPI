# Use Node.js v14 as base image
FROM node:14 AS node-app

# Rust app
FROM rust:1.54 AS rust-app
WORKDIR /

RUN rustup update
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl
COPY . .
RUN cargo build --release


# Final image
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y libssl1.1
WORKDIR /
COPY --from=node-app ./dist ./dist
COPY --from=node-app ./data ./data

COPY --from=rust-app /target/release/restapi ./restapi

ENV JSON_FILE=DokkanCharacterData.json

ENV PORT=1000

EXPOSE 1000
CMD ["./restapi"]