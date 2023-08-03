# --------- BUILDER -----------
# see Makefile.version
ARG AMAZONCORRETTO_VERSION
ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION} AS builder

ARG LT_VERSION
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    python3-dev \
    unzip \
    python3-numpy \
    python3-scipy \
    curl \
    openjdk-19-jdk

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText && \
    cd /tmp/fastText && \
    make

RUN wget https://www.languagetool.org/download/LanguageTool-$LT_VERSION.zip && \
    unzip LanguageTool-$LT_VERSION.zip && \
    mv /LanguageTool-$LT_VERSION /LanguageTool 

# --------- WORKER -----------
FROM amazoncorretto:${AMAZONCORRETTO_VERSION}
WORKDIR /LanguageTool
COPY --from=builder /tmp/fastText ./
COPY --from=builder /LanguageTool ./
ADD misc/config.txt config.txt
ADD lid.bin lid.bin
EXPOSE 8081
USER nobody
CMD java -cp languagetool-server.jar  org.languagetool.server.HTTPServer --port 8081 --public --allow-origin '*' --config config.txt