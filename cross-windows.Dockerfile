FROM debian:stable-backports
RUN sed 's|deb |deb-src |g' /etc/apt/sources.list | tee /etc/apt/sources.list.d/sources.list
RUN apt-get update && apt-get dist-upgrade && apt-get build-dep firefox-esr -y && apt-get install -y wget curl make git
RUN adduser --disabled-password --gecos 'user,,,,' user
COPY . /home/user/gnuzilla/
WORKDIR /home/user/gnuzilla/
RUN make deps

#	wget -O /builds/worker/workspace/build/src/nsis.tar.gz https://firefox-ci-tc.services.mozilla.com/api/index/v1/task/gecko.cache.level-3.toolchains.v3.linux64-mingw32-nsis.latest/artifacts/public/build/nsis.tar.xz
#	cd /builds/worker/workspace/build/src/ &&
#		tar xvzf nsis.tar.gz
