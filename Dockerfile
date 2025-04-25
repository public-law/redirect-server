FROM elixir:1.18.3-otp-27

# install build dependencies
RUN apt-get update && apt-get install -y build-essential inotify-tools curl git npm

# install Node.js (Phoenix assets)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt-get install -y nodejs

# prepare working directory
WORKDIR /app

# set environment to prod by default
ENV MIX_ENV=prod

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

# cache deps
COPY mix.exs mix.lock ./
RUN mix deps.get && mix deps.compile

# copy source and compile
COPY . .

# compile application
RUN mix compile
RUN mix release

# expose port and run app
EXPOSE 4000
CMD ["/app/_build/prod/rel/redirector/bin/redirector", "start"]
