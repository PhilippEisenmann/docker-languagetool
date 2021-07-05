FROM ubuntu:bionic
# see Makefile.version
ARG VERSION

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    python-dev \
    unzip \
    python-numpy \
    python-scipy \
    curl \
    openjdk-11-jdk \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText && \
    rm -rf /tmp/fastText/.git* && \
    mv /tmp/fastText/* / && \
    cd / && \
    make
    
RUN wget https://www.languagetool.org/download/LanguageTool-$VERSION.zip && \
    unzip LanguageTool-$VERSION.zip && \
    mv /LanguageTool-$VERSION /LanguageTool &&\
    rm LanguageTool-$VERSION.zip
    
RUN mkdir ngram &&\
    curl -# -o ngram/NGRAM_DE.zip $(NGRAM_DE) && \
    unzip -n ngram/NGRAM_DE.zip -d ngram/ && \
    curl -# -o ngram/NGRAM_EN.zip $(NGRAM_EN) &&\
    unzip -n ngram/NGRAM_EN.zip -d ngram/ && \
    rm ngram/NGRAM_*.zip && \
    curl -# -o lid.bin $(FASTTEXTMODEL)

WORKDIR /LanguageTool-$VERSION

ADD misc/start.sh /start.sh
ADD misc/config.txt /LanguageTool/config.txt
ADD lid.bin /lid.bin
CMD [ "sh", "/start.sh" ]
USER nobody
EXPOSE 8010

