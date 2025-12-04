# Dockerized Hugo Extended Edition

https://github.com/gohugoio/hugo

## Getting Started

Build:

```text
docker build -t my-hugo-image:1.0 .
```

Example Usage:

```text
docker run --rm -it -v $(pwd):/site -p 1313:1313 --expose 1313 my-hugo-image:1.0 serve -D --environment=development --bind=0.0.0.0
```
