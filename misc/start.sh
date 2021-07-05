#!/bin/bash
java -cp LanguageTool/languagetool-server.jar  org.languagetool.server.HTTPServer --port 8010 --public --allow-origin '*' --config config.txt
