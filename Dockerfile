FROM lappis/decidim-govbr:v1-release

WORKDIR /decidim-govbr
COPY . .

RUN bundle install
RUN npm install
RUN yarn

RUN gem install mailcatcher --no-document

COPY .env.dev /decidim-govbr/.env

CMD ["/bin/bash -l -c \"chmod +x start.sh && ./start.sh\""]