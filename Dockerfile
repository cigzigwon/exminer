FROM elixir:1.8-alpine

# Install hex
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

WORKDIR /usr/src/apps

CMD ["iex", "-S", "mix"]
