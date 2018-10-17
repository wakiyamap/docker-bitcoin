#!/bin/bash
set -e

if [[ "$1" == "bitcoin-cli" || "$1" == "bitcoin-tx" || "$1" == "bitcoind" || "$1" == "test_bitcoin" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoin.conf"

	# 0.17.0 expected the sections for mainnet and testnet to be called main and test.
	# If you need testnet, you normally need a configuration file with
	# testnet=1
	# [test]
	# blahblah=1
	# It would require that configuration file produced by some templating engine takes 2 parameters
	# instead of 1 (testnet and test)
	# We fix this stupid design decision by accepting [testnet] or [mainnet] sections, and replacing
	# them with [test] and [main]
	sed -i "s/\[testnet\]/\[test\]/g" "$BITCOIN_DATA/bitcoin.conf"
	sed -i "s/\[mainnet\]/\[main\]/g" "$BITCOIN_DATA/bitcoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin
	chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
