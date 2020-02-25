#!/bin/bash
docker run -it --rm -e MIX_ENV=test -v $(pwd):/usr/src/apps cigzigwon/elixir mix test --listen-on-stdin
# docker run -it --rm -e MIX_ENV=dev -v $(pwd):/usr/src/apps cigzigwon/elixir
