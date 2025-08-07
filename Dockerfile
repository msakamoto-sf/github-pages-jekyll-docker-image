FROM debian:bookworm-slim

RUN apt-get update \
 && apt-get install -y \
    ruby3.1 \
    ruby3.1-dev \
    build-essential \
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /ruby-tools/gems
ENV GEM_HOME="/ruby-tools/gems"
ENV PATH="/ruby-tools/gems/bin:${PATH}"
RUN gem install bundler
# current supported version = 232 at 2025-08-07
# https://rubygems.org/gems/github-pages/versions/232
# via: https://pages.github.com/versions/
RUN gem install github-pages -v 232

CMD ["/bin/bash"]