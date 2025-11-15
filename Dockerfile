# Using Debian 12 ("bookworm") — stable and LTS-supported as of Oct 2025
FROM ruby:3.4.7-bookworm

# Install system dependencies
# Clean up APT lists afterward to reduce final image size (no longer needed after install)
RUN apt-get update -qq && apt-get install -y build-essential \
                                             libpq-dev \
                                             nodejs \
                                             yarn \
                                             && rm -rf /var/lib/apt/lists/*

# Define working directory inside the container
WORKDIR /app

# Copy project dependency manifests
COPY Gemfile .
COPY Gemfile.lock .

# Install Ruby gems
ENV BUNDLE_PATH=/usr/local/bundle
RUN bundle install
