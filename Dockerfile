ARG MIX_ENV="prod"

# build stage
#FROM hexpm/elixir:1.14.2-erlang-25.1.2-alpine-3.16.2 AS build
#FROM hexpm/elixir:1.13.0-erlang-25.1.2-alpine-3.16.2 AS build
FROM hexpm/elixir:1.12.3-erlang-24.1.2-alpine-3.14.2 AS build

# install build dependencies
RUN apk add --no-cache build-base git python3 curl

# sets work dir
WORKDIR /app

# install hex
RUN mix local.hex --force \
    && mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# copy compile configuration files
RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/

# copy assets
COPY priv priv
COPY assets assets

# compile assets

RUN mix assets.deploy

# compile project
COPY lib lib
RUN mix compile

# copy runtime configuration file
COPY config/runtime.exs config/

# assemble release
RUN mix phx.gen.release
RUN mix release

# app stage
FROM alpine:3.16.3 AS app

ARG MIX_ENV

# install runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

ENV USER="elixir"

WORKDIR "/home/${USER}/app"

# Create  unprivileged user to run the release
RUN \
  addgroup \
   -g 1000 \
   -S "${USER}" \
  && adduser \
   -s /bin/sh \
   -u 1000 \
   -G "${USER}" \
   -h "/home/${USER}" \
   -D "${USER}"\
  && su "${USER}"

# run as user
USER "${USER}"

# copy release executables
COPY --from=build --chown="${USER}":"${USER}" /app/_build/"${MIX_ENV}"/rel/hiverec ./

ENTRYPOINT ["bin/server"]

CMD ["start"]
