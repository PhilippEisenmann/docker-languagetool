# Introduction

[LanguageTool] is an Open Source proof­reading software for English, French,
German, Polish, and more than 20 other languages.

You can use the LanguageTools with a [firefox-plugin].

This is a Dockerfile to get the languagetools running on a system without java.

[LanguageTool]: https://www.languagetool.org/
[firefox-plugin]: https://addons.mozilla.org/firefox/addon/languagetoolfx/

# Build and Usage
to build the docker image run:

    make build

If you would like to change the names see:

    Makefile.version
## ngram support

ngram download and unzip is included in the docker make build.
for testing you can change to a local server: 

    make local_server=1 <target>

see also the 
    
    Makefile.version

## show build settings

    make envout

## switch NGRAM download server

    make local_server=1 envout

## start
docker compose up -d