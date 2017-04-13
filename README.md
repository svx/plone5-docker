# Plone 5 in Docker - Demo

Plone 5 in Docker

## Usage

Without mounted data dir:

```
docker run --rm -d -p 8080:8080 --name plone5-test plone5-docker
```

With data mount, aka keep your content

Create needed directories on your host system

```
mkdir plone5-test
cd plone5-test
mkdir data
mkdir -p data/filestorage
mkdir -p data/blobstorage
mkdir -p data/log

docker run --rm -d -v "${PWD}"/data:/data -p 8080:8080 --name plone5-test plone5-docker
```

This ensures that your data is still there, after a container shutdown/restart

## Building

Clone this repository

```
git clone https://github.com/svx/plone5-docker
```

Change into it

```
cd plone5-docker
```

Build the image

```
docker build --no-cache=true -t plone5-docker .
```

