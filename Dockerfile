FROM lappis/decidim-govbr:v1-release

WORKDIR /decidim-govbr
COPY . .

RUN apt-get update && apt-get install pandoc -y
RUN bundle install
RUN yarn

COPY .env.dev /decidim-govbr/.env

CMD ["/bin/bash -l -c \"chmod +x start.sh && ./start.sh\""]
