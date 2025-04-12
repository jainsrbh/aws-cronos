# Use official Nginx image
FROM nginx:1.23-alpine

# Create directories for configuration and certificates
RUN mkdir -p /etc/nginx/ssl && \
    mkdir -p /var/log/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /var/cache/nginx

# Copy custom Nginx configuration
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./certs/ca.crt /etc/nginx/ssl/ca.crt
COPY ./certs/ca.key /etc/nginx/ssl/ca.key
COPY ./certs/server.crt /etc/nginx/ssl/server.crt
COPY ./certs/server.key /etc/nginx/ssl/server.key

# Set permissions
RUN chmod 600 /etc/nginx/ssl/*.key && \
    chmod 644 /etc/nginx/ssl/*.crt && \
    chown -R nginx:nginx /etc/nginx/ssl

# Expose ports
EXPOSE 8000 8001

# Run as non-root user
USER nginx

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]