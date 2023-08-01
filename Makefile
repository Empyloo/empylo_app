.PHONY: run-dev run

run-dev:
	flutter run -d chrome -t lib/dev_main.dart

run:
	flutter run -d chrome

exp:
	dart experiments_cred.dart