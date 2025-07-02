# Use official PHP Apache image
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies for PHPMailer and cURL
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql curl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files
COPY . /var/www/html/

# Install PHPMailer via Composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set permissions for data directory
RUN chown -R www-data:www-data /var/www/html/data \
    && chmod -R 755 /var/www/html/data

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
