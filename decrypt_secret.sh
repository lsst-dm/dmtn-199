#!/bin/sh

# Decrypt the file
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$TOKEN_PASSPHRASE" \
	--output token.pickle token.pickle.gpg
