all: index

index: index.html logos/*.svg
	tools/update-index.coffee
