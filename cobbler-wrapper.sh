#!/bin/bash
ARGS="cobbler $@"
docker exec -it cobbler /bin/bash -c "$ARGS"
