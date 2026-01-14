# Dockerized Hugo Extended Edition

https://github.com/gohugoio/hugo

## Usage Examples:

Build:

```text
docker build -t ip10111/hugo:1.0 .
```

New Hugo site:
```text
docker run --rm -it -v $(pwd):/site -p 1313:1313 --expose 1313 ip10111/hugo:1.0 new site .
```

Hugo serve:
```text
docker run --rm -it -v $(pwd):/site -w /site -p 1313:1313 --expose 1313 ip10111/hugo:1.0 serve -D --environment=development --bind=0.0.0.0
```
