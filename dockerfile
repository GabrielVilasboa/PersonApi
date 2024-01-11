FROM node:11.15.0  as build-stage

# Criar e definir o diretório de trabalho
WORKDIR /var/www

# Copiar o resto dos arquivos da aplicação para o diretório de trabalho
COPY . .

# Instalar as dependências
RUN npm install

# Buildar
RUN npm run prod

FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www

#Copiar Build para workdir
COPY --from=build-stage /var/www /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    libldap2-dev \
    curl \
    libonig-dev \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap
RUN docker-php-ext-configure bcmath --enable-bcmath
RUN docker-php-ext-install bcmath

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar permissões para o diretório de fontes do DOMPDF
RUN mkdir -p /var/www/vendor/dompdf/dompdf/lib/fonts && chown -R www-data:www-data /var/www/vendor/dompdf/dompdf/lib/fonts && chmod -R 755 /var/www/vendor/dompdf/dompdf/lib/fonts

# Permissão de escrita no diretório /tmp
RUN mkdir /temp && chmod 777 /temp -R

# Expose port 9000 and start php-fpm server
EXPOSE 9000

ENTRYPOINT [ "/var/www/entrypoint.sh" ]
