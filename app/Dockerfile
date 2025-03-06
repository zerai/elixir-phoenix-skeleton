# Extend from the official Elixir image.
FROM elixir:1.18.2-otp-27 AS elixir_upstream

# The different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target

# Base elixir image
FROM elixir_upstream AS elixir_base

WORKDIR /app

# Install debian packages
RUN apt-get update 
RUN apt-get install --yes build-essential \
    inotify-tools \
    postgresql-client

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs


# Dev elixir image
FROM elixir_base AS elixir_dev

COPY --link --chmod=755 ../sys/docker/app/dev_entrypoint.sh /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
EXPOSE 4000
EXPOSE 433
EXPOSE 80



# Prod elixir image
FROM elixir_base AS elixir_prod

ENV MIX_ENV=prod
EXPOSE 433
EXPOSE 80
