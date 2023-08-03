# Introduction

[LanguageTool] is an Open Source proof­reading software for English, French,
German, Polish, and more than 20 other languages.

You can use the LanguageTools with a [firefox-plugin].

This is a Dockerfile to get the languagetools running on a system without java.
It will also install ngram and fasttext for you inside the docker image.

The worker image will use [https://hub.docker.com/_/amazoncorretto]

[LanguageTool]: https://www.languagetool.org/
[firefox-plugin]: https://addons.mozilla.org/firefox/addon/languagetoolfx/

# Build and Usage
Check the enviroment variables and versions that will be uses:

    make envout

To build the docker image run:

    make build_docker

to get the NGRAM files use:

    make build_ngram

To run the docker image, check the path where the ngams have been extracted to and alter the `docker-compose.yaml`

    docker compose up 

If you would like to change the names / versions see:

    Makefile.version
## start

    docker compose up -d

# Development and test
## ngram support

Ngram download and unzip is included in the docker make build. For testing you can change to a local server: 

    make local_server=1 <target>

see also the 
    
    Makefile.version

## show build settings

    make envout

## switch ngram download server to local

    make local_server=1 envout