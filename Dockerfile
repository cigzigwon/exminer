FROM elixir:slim

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /usr/src/apps

CMD ["iex", "-S", "mix"]
