FROM ruby:3.4-slim

# Install system dependencies required to build many Ruby gems and run common asset pipelines.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    ca-certificates \
    nodejs \
    imagemagick \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the dev server
RUN useradd -m -u 1000 jekyll
WORKDIR /srv/jekyll

# Copy only Gemfile / Gemfile.lock first for Docker layer caching
COPY Gemfile Gemfile.lock* /srv/jekyll/

# Install gems
ENV BUNDLE_PATH=/usr/local/bundle
RUN bundle config set deployment 'false' && \
    bundle config set without 'development' || true && \
    bundle install --jobs 4 --retry 3

# Copy the rest of the site
COPY . /srv/jekyll

# Fix permissions for the non-root user
RUN chown -R jekyll:jekyll /srv/jekyll

USER jekyll

ENV JEKYLL_ENV=development

# Expose Jekyll default port
EXPOSE 4000

# Default command:
# - bind to 0.0.0.0 so the server is accessible outside the container
# - use --incremental for faster rebuilds (good for local dev)
# - use --watch so changes in mounted volume trigger rebuilds
CMD ["bash", "-lc", "exec bundle exec jekyll serve --host 0.0.0.0 --port 4000 --watch --incremental"]
