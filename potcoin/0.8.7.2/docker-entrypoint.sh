#!/bin/bash
set -e

if [[ "$1" == "potcoin-cli" || "$1" == "potcoin-tx" || "$1" == "potcoind" || "$1" == "test_potcoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/potcoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/potcoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.potcoin
	chown -h bitcoin:bitcoin /home/bitcoin/.potcoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
