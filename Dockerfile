FROM lappis/decidim-govbr:v1-release

WORKDIR /decidim-govbr
COPY . .

COPY .env.dev /decidim-govbr/.env

CMD ["/bin/bash -l -c \"chmod +x start.sh && ./start.sh\""]
