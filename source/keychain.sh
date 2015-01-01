KEYS=(id_rsa id_ecdsa)

if command keychain >/dev/null 2>&1; then
	# Let's keychain it up in this fucker.
	eval $(keychain --eval --agents ssh -Q --quiet $KEYS)
fi
