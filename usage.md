

# Tutorial: Building and Deploying Your Hugo Dance Blog with Docker on Railway

In this tutorial, you will learn how to:

1. Create a new Hugo site and integrate the Pehtheme Hugo theme.
2. Create new posts for your blog.
3. Build your Hugo site using a Dockerfile.
4. Deploy your Dockerized site on Railway.

---

## 1. Set Up Your Hugo Site

### a. Create a New Hugo Site

Open your terminal and create a new Hugo site:
```bash
hugo new site my-dance-blog
```
This creates a folder named `my-dance-blog` with the basic Hugo structure.

### b. Integrate the Pehtheme Hugo Theme

1. **Clone the Theme:**  
   Change into your site’s directory, create a `themes` folder, and clone the theme:
   ```bash
   cd my-dance-blog
   mkdir themes
   cd themes
   git clone https://github.com/fauzanmy/pehtheme-hugo.git
   ```
   This places the theme in `my-dance-blog/themes/pehtheme-hugo`.

2. **Copy the Example Files:**  
   The theme’s `exampleSite` contains sample configuration and content. Copy these files into your site’s root (i.e., back in `my-dance-blog`):
   - Copy the folders `assets/` and `content/`
   - Copy the file `hugo.toml`
   
   This will set up your site with the theme’s configuration and sample content.

---

## 2. Creating New Posts

You can create posts using the Hugo command or by manually adding Markdown files.

### Using the Command Line

1. **Create a New Post:**  
   Navigate to your Hugo site root (`my-dance-blog`) and run:
   ```bash
   hugo new posts/my-first-dance-post.md
   ```
   This command creates a new Markdown file under `content/posts/` with pre-populated front matter.

2. **Edit the Post:**  
   Open the generated file (e.g., in VS Code) and update the front matter and content. For example:
   ```markdown
   ---
   title: "My First Dance Post"
   date: 2025-03-14T10:00:00Z
   draft: true
   tags: ["dance", "performance"]
   ---

   Welcome to my first dance post! Here, I'll share my experiences and photos.
   ```

3. **Preview Locally:**  
   Run Hugo's server:
   ```bash
   hugo server -D
   ```
   Open [http://localhost:1313](http://localhost:1313) to preview your post. (The `-D` flag includes drafts.)

### Manually Creating a Post

1. **Navigate to the Content Folder:**  
   Open the `content/posts/` directory.

2. **Create a Markdown File:**  
   Create a file (e.g., `my-second-dance-post.md`) and add the front matter and Markdown content.
   
3. **Save and Preview:**  
   Save the file and run `hugo server -D` to see the changes.

---

## 3. Build Your Site with Docker

Next, create a Dockerfile that builds your Hugo site and serves it with Nginx.

### a. Create the Dockerfile

Place the following Dockerfile at the root of your repository (i.e., in the same folder as your `railway.json`, README, etc.):

```dockerfile
# Stage 1: Build the Hugo site
FROM klakegg/hugo:ext-alpine AS builder
WORKDIR /app
# Copy the entire repository into /app
COPY . .
# Change directory into your Hugo site and build the site with minification
RUN cd my-dance-blog && hugo --minify

# Stage 2: Serve the built site with Nginx
FROM nginx:alpine
# Copy the generated static files from the builder stage into Nginx's default folder
COPY --from=builder /app/my-dance-blog/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### b. Explanation

- **Stage 1 (Builder):**  
  Uses the extended Hugo image to build your site in the `my-dance-blog` directory. The output is generated into `my-dance-blog/public`.

- **Stage 2 (Runtime):**  
  Uses a lightweight Nginx container to serve the static files from `/usr/share/nginx/html`.  
  The `EXPOSE 80` instruction indicates that Nginx listens on port 80. When Railway deploys the container, it will map Railway’s public port to the container’s port 80.

---

## 4. Deploy Your Dockerized Site on Railway

### a. Push Your Repository to GitHub

Make sure your repository is up-to-date (including your Dockerfile, Hugo site, and other files). Then commit and push:

```bash
git add .
git commit -m "Set up Hugo site with Pehtheme and Dockerfile"
git push
```

### b. Deploy on Railway

1. **Log in to Railway:**  
   Go to [Railway](https://railway.app/) and log in.

2. **Create a New Project:**  
   Select “Deploy from GitHub” and choose your repository.

3. **Railway Detection:**  
   Railway will detect the Dockerfile. The container will be built and deployed automatically.

4. **Port Mapping:**  
   Your container listens on port 80 (as defined by `EXPOSE 80` in the Dockerfile). Railway will map its dynamic public URL to your container’s port 80, so your site is served correctly.

5. **Access Your Site:**  
   Once the deployment finishes, Railway provides you with a public URL where your Hugo site is live.
