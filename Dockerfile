# syntax=docker/dockerfile:1

#############################
# Stage 1 — Build (Hugo + CSS)
#############################
FROM klakegg/hugo:0.148.2-ext-alpine AS builder
WORKDIR /app/my-dance-blog

# Node for Tailwind/PostCSS
RUN apk add --no-cache nodejs npm

# Install npm deps first for caching
COPY my-dance-blog/package*.json ./
COPY my-dance-blog/postcss.config.js* my-dance-blog/tailwind.config.js* ./
RUN npm ci

# Copy the rest of the site
COPY my-dance-blog/ ./

# Build CSS (Tailwind + PostCSS) → static/css/main.css
RUN npx tailwindcss -i assets/input.css -o static/css/main.css --postcss --minify

# Build Hugo (set BASE_URL at build time if you want absolute URLs)
ARG BASE_URL=/
ENV HUGO_ENV=production
RUN hugo --minify --baseURL "${BASE_URL}"

# Fail hard if Hugo produced nothing
RUN test -f public/index.html || (echo "❌ Hugo did not produce public/index.html" && exit 1)

#############################
# Stage 2 — Runtime (Nginx)
#############################
FROM nginx:alpine
# Optional: custom caching
# COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/my-dance-blog/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
