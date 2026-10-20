FROM rust:1-bookworm AS build
ARG JEVHOME_REPO=https://github.com/Jibril-Frej/jev-at-home
ARG JEVHOME_REF=1be5ac1f6ce1
RUN git clone "$JEVHOME_REPO" /src && cd /src && git checkout --detach "$JEVHOME_REF"
WORKDIR /src
RUN cargo build --release --locked

FROM gcr.io/distroless/cc-debian12:nonroot
COPY --from=build /src/target/release/jevhome /jevhome
EXPOSE 8009
ENTRYPOINT ["/jevhome"]
CMD ["serve", "/models/jevhome-B-int8", "--host", "0.0.0.0"]
