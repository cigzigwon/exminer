#!/bin/bash
docker run -it --rm -e MIX_ENV=test -v $(pwd):/usr/src/apps cigzigwon/elixir:1.8-alpine mix test
# docker run -it --rm -e MIX_ENV=dev -v $(pwd):/usr/src/apps cigzigwon/elixir:1.8-alpine iex -S mix
