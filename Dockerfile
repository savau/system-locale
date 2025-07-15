FROM haskell:9.10.1

RUN apt-get update && apt-get -y --no-install-recommends install locales-all

WORKDIR /opt/system-locale

RUN cabal update

# Add just the .cabal file to capture dependencies
COPY ./system-locale.cabal /opt/system-locale/system-locale.cabal

# Docker will cache this command as a layer, freeing us up to
# modify source code without re-installing dependencies
# (unless the .cabal file changes!)
RUN cabal build --only-dependencies -j4

# Add and Install Application Code
COPY . /opt/system-locale
RUN cabal test