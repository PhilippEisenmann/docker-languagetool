# see Makefile.version
ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}

ARG LTVersion
RUN echo $LTVersion

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    python3-dev \
    unzip \
    python3-numpy \
    python3-scipy \
    curl \
    openjdk-19-jdk \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText && \
    rm -rf /tmp/fastText/.git* && \
    mv /tmp/fastText/* / && \
    cd / && \
    make
    
RUN wget https://www.languagetool.org/download/LanguageTool-$LTVersion.zip && \
    unzip LanguageTool-$LTVersion.zip && \
    mv /LanguageTool-$LTVersion /LanguageTool &&\
    rm LanguageTool-$LTVersion.zip

WORKDIR /LanguageTool
ADD misc/config.txt /LanguageTool/config.txt
ADD lid.bin /lid.bin
EXPOSE 8081
USER nobody
CMD java -cp languagetool-server.jar  org.languagetool.server.HTTPServer --port 8081 --public --allow-origin '*' --config config.txt

# todo add amazoncorretto as runner