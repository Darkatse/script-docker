FROM ubuntu:20.04
MAINTAINER Darkatse <x.yngtze.river@gmail.com>

ARG env_count
ENV DEBIAN_FRONTEND="noninteractive"
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections; \
    sed -Ei 's/security.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list; \
    sed -Ei 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list;


RUN date && apt update && apt install -y cron openssl coreutils git wget tzdata \
         && apt update && apt install -y python3 python3-pip && apt install -y nodejs npm dos2unix

WORKDIR /

COPY ./env/ /env/
COPY ./scripts/ /sripts_colle/
COPY ./sync.sh /sync.sh
RUN bash /sync.sh
CMD crontab -l && cron -f