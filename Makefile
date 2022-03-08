#!/usr/bin/make -f

test:
	cd apps/firestore_snippets && flutter test

build:
	cd app/firestore_snippets && flutter build
