# Use official PHP Apache image
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install cURL and libcurl development libraries
RUN apt-get update && apt-get install -y \
    curl \
    libcurl4-openssl-dev \
    pkg-config \
    && docker-php-ext-install curl

# Copy application files
COPY . /var/www/html/

# Create data directory and set permissions
RUN mkdir -p /var/www/html/data \
    && chown -R www-data:www-data /var/www/html/data \
    && chmod -R 755 /var/www/html/data

# Enable Apache rewrite module
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
