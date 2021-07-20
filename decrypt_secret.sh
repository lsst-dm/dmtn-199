#!/bin/sh
# gpg -c  to create 
# Decrypt the file
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$TOKEN_PASSPHRASE" \
	--output tables/token.pickle token.pickle.gpg
