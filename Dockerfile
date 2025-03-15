# Stage 1: Build the Hugo site
FROM klakegg/hugo:ext-alpine AS builder
WORKDIR /app
# Copy the entire repository into /app
COPY . .
# Change directory to the Hugo site and build it with minification
#RUN cd my-dance-blog && hugo --minify

# Stage 2: Serve the built site using Nginx
FROM nginx:alpine
# Copy the generated static files from the builder stage
COPY --from=builder /app/my-dance-blog/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
