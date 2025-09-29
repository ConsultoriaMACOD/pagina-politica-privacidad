# Build a tiny static site image using nginx
# Uses official nginx image and copies the site into /usr/share/nginx/html
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy site
COPY . /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start nginx (default cmd)
CMD ["nginx", "-g", "daemon off;"]
