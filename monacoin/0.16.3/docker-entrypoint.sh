#!/bin/bash
set -e

if [[ "$1" == "monacoin-cli" || "$1" == "monacoin-tx" || "$1" == "monacoind" || "$1" == "test_monacoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/monacoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/monacoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.monacoin
	chown -h bitcoin:bitcoin /home/bitcoin/.monacoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
