#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
    FROM php:8.3-fpm

    # Set working directory
    WORKDIR /var/www
    
    #--------------------------------------------------------------------------
    # Software's Installation
    #--------------------------------------------------------------------------
    # Installing tools and PHP extensions using "apt", "docker-php", "pecl",
    RUN set -eux; \
        apt-get update; \
        apt-get upgrade -y; \
        apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype6-dev \
            libssl-dev \
            libwebp-dev \
            libxpm-dev \
            libonig-dev; \
        rm -rf /var/lib/apt/lists/*
    
    # Install PHP extensions
    RUN set -eux; \
        docker-php-ext-install pdo_mysql pdo_pgsql; \
        docker-php-ext-configure gd --with-jpeg --with-webp --with-xpm --with-freetype; \
        docker-php-ext-install gd
    
    # Add user for laravel application
    RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/bash -g www www
    
    # Install composer
    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
    
    # Copy existing application directory contents
    COPY . /var/www
    
    # Set permissions for Laravel storage and cache
    RUN chown -R www:www /var/www && \
        chown -R www:www /var/www/storage /var/www/bootstrap/cache
    
    # Copiar configuración personalizada de PHP-FPM
    COPY ./docker/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
    
    # Expose port 9000 and start php-fpm server
    EXPOSE 9000
    CMD ["php-fpm"]
    