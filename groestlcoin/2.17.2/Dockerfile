FROM debian:stretch-slim

RUN groupadd -r groestlcoin && useradd -r -m -g groestlcoin groestlcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu wget \
	&& rm -rf /var/lib/apt/lists/*

ENV GROESTLCOIN_VERSION 2.12.2
ENV GROESTLCOIN_URL https://github.com/Groestlcoin/groestlcoin/releases/download/v2.17.2/groestlcoin-2.17.2-x86_64-linux-gnu.tar.gz
ENV GROESTLCOIN_SHA256 0eed1a10f8dbb5a361bf74ee201acc47a124abb8916f66a263c95b8f9d1173b0
ENV GROESTLCOIN_ASC_URL https://github.com/Groestlcoin/groestlcoin/releases/download/v2.17.2/SHA256SUMS.asc
ENV GROESTLCOIN_PGP_KEY 287AE4CA1187C68C08B49CB2D11BD4F33F1DB499

# install groestlcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO groestlcoin.tar.gz "$GROESTLCOIN_URL" \
	&& echo "$GROESTLCOIN_SHA256 groestlcoin.tar.gz" | sha256sum -c - \
	&& gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$GROESTLCOIN_PGP_KEY" \
	&& wget -qO groestlcoin.asc "$GROESTLCOIN_ASC_URL" \
	&& gpg --verify groestlcoin.asc \
	&& tar -xzvf groestlcoin.tar.gz -C /usr/local/bin --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV GROESTLCOIN_DATA /data
RUN mkdir "$GROESTLCOIN_DATA" \
	&& chown -R groestlcoin:groestlcoin "$GROESTLCOIN_DATA" \
	&& ln -sfn "$GROESTLCOIN_DATA" /home/groestlcoin/.groestlcoin \
	&& chown -h groestlcoin:groestlcoin /home/groestlcoin/.groestlcoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 1331 1441 17777 17766 18888 18443
CMD ["groestlcoind"]
