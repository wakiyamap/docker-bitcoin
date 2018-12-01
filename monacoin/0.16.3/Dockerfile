FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV MONACOIN_VERSION 0.16.3
ENV MONACOIN_URL https://github.com/monacoinproject/monacoin/releases/download/monacoin-0.16.3/monacoin-0.16.3-x86_64-linux-gnu.tar.gz
ENV MONACOIN_SHA256 9de01a4facd3dab6a9fdaa68f5d8ae0e464c058920f6e3ec106bcd5bad238d1c
ENV MONACOIN_ASC_URL https://github.com/monacoinproject/monacoin/releases/download/monacoin-0.16.3/monacoin-0.16.3-signatures.asc
ENV MONACOIN_PGP_KEY 45C7DEE9BC1871A8

# install monacoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO monacoin.tar.gz "$MONACOIN_URL" \
	&& echo "$MONACOIN_SHA256 monacoin.tar.gz" | sha256sum -c - \
	&& gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$MONACOIN_PGP_KEY" \
	&& wget -qO monacoin.asc "$MONACOIN_ASC_URL" \
	&& gpg --verify monacoin.asc \
	&& tar -xzvf monacoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.monacoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.monacoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9401 9402 19403 19402 19443 20444
CMD ["monacoind"]
