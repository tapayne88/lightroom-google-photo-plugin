test:
	nix-shell --command 'busted --lpath ./tests/?.lua --directory ./google-photo.lrplugin ./tests'
