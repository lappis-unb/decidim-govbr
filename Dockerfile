FROM ruby:3.0.4-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    libpq-dev

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get install -y nodejs

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y yarn

WORKDIR /decidim-govbr
COPY . .

RUN bundle install
RUN npm install
RUN yarn

RUN gem install mailcatcher --no-document

COPY .env.dev /decidim-govbr/.env

# RUN mailcatcher --http-ip=0.0.0.0 &
# RUN bundle exec sidekiq &

# RUN rails db:create db:migrate

# CMD ["rails" "s" "-b 0.0.0.0" "-p 3000"]
CMD ["/bin/bash -l -c \"chmod +x start.sh && ./start.sh\""]