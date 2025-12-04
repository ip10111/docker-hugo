# --- STAGE 1: Build the Hugo Extended Binary ---
FROM golang:1.21.0-alpine AS builder

# 1. Install critical build dependencies in a single layer:
#    - git: Required for Go Modules to fetch Hugo.
#    - gcc, g++, musl-dev: The full C/C++ toolchain necessary for CGO_ENABLED=1 
#      to link the LibSass embedded in the "extended" build.
RUN apk add --no-cache \
        g++ \
        gcc \
        git \
        musl-dev && \
    # Clean up the package cache immediately after install
    rm -rf /var/cache/apk/*

# Set the Go working directory
WORKDIR /src

# 2. Build Hugo Extended from source
#    - CGO_ENABLED=1 is MANDATORY for building the Extended version.
#    - -tags extended is MANDATORY to include LibSass functionality.
#    Using a specific stable version (e.g., v0.121.2) can sometimes be safer than @latest.
RUN CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@v0.152.2

# --- STAGE 2: Create the Minimal Runtime Image (Hugo Build Tool) ---
FROM alpine:latest AS hugo-runtime

# 1. Install runtime dependencies for the built CGO binary:
#    These are the libraries the compiled binary needs to execute.
RUN apk add --no-cache \
        libstdc++ \
        libgcc

# 2. Copy the compiled 'hugo' binary
#    The binary is located in /go/bin in the Go image.
COPY --from=builder /go/bin/hugo /usr/local/bin/hugo

# 3. Verify the installation and extended status
RUN hugo version

# Set the default working directory and entrypoint
WORKDIR /src
ENTRYPOINT ["hugo"]
