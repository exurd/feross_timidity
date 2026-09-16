# docker build -o . .
FROM emscripten/emsdk:6.0.8 AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN npm install && ./tools/build.sh

FROM scratch AS exporter

COPY --from=builder /src/libtimidity.wasm /
COPY --from=builder /src/libtimidity.js /
COPY --from=builder /src/libtimidity.debug.wasm /
COPY --from=builder /src/libtimidity.debug.wasm.map /
COPY --from=builder /src/libtimidity.debug.js /
