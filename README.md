# php-composer-yarn

A docker image with PHP Composer and Yarn.

Use as:

```bash
docker container run --rm --interactive --tty \
	--volume "$PWD":/app laurocesar/php-composer-yarn:latest \
	"./install-dependencies.sh"
```

Where `install-dependencies.sh` should look like:

```bash
#!/bin/bash

# ----------------------------------------------------------------------
# Run Composer
# ----------------------------------------------------------------------
composer update --prefer-dist
composer dump-autoload -o

# ----------------------------------------------------------------------
# Run Yarn
# ----------------------------------------------------------------------
yarn install
```