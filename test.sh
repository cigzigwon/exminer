#!/bin/bash
docker run -it --rm -v $(pwd):/usr/src/apps cigzigwon/elixir:1.8-alpine mix test
