#!/bin/bash

docker build . -t laurocesar/php-composer-yarn:latest

docker push laurocesar/php-composer-yarn:latest

# iteractive
# docker container run -it -v "$PWD":/app --rm laurocesar/php-composer-yarn bash