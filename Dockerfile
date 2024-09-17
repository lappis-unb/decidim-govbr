FROM lappis/decidim-govbr:v1-release

WORKDIR /decidim-govbr
COPY . .

RUN apt-get update -qq && apt-get install pandoc -y
RUN bundle install
RUN gem install debase -v 0.2.5.beta2
RUN gem install ruby-debug-ide -v 0.7.3
RUN yarn

COPY .env.dev /decidim-govbr/.env

CMD ["/bin/bash -l -c \"chmod +x start.sh && ./start.sh\""]
