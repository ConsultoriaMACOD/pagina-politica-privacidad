# Build a tiny static site image using nginx
# Uses official nginx image and copies the site into /usr/share/nginx/html
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy site
COPY . /usr/share/nginx/html

# Copy custom nginx configuration to ensure nginx listens on 0.0.0.0:80 and
# provides a simple SPA-friendly fallback and sensible caching for static assets.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Add a simple healthcheck so Coolify / reverse-proxies can verify the container
# is serving HTTP before routing traffic to it.
HEALTHCHECK --interval=20s --timeout=3s --start-period=5s --retries=3 \
	CMD wget -q -O /dev/null http://127.0.0.1:80/ || exit 1

# Start nginx (default cmd)
CMD ["nginx", "-g", "daemon off;"]
