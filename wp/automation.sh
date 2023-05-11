apt-get -y update && apt-get -y install vim curl unzip
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp-cli

echo "Configuring Wordpress parameters..."
rm -f /var/www/html/wp-config.php
cd /var/www/html/
wp-cli --allow-root core config \
		--dbhost=${WORDPRESS_DB_HOST} \
		--dbname=${WORDPRESS_DB_NAME} \
		--dbuser=${WORDPRESS_DB_USER} \
		--dbpass=${WORDPRESS_DB_PASSWORD} \
		--locale=${WORDPRESS_LOCALE} \
		--skip-check

wp-cli --allow-root core install \
	    --url=${WORDPRESS_WEBSITE_URL_WITHOUT_HTTP} \
		--title="${WORDPRESS_WEBSITE_TITLE}" \
		--admin_user=${WORDPRESS_ADMIN_USER} \
		--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
		--admin_email=${WORDPRESS_ADMIN_EMAIL}

wp-cli --allow-root option update siteurl "${WORDPRESS_WEBSITE_URL}"
wp-cli --allow-root rewrite structure ${WORDPRESS_WEBSITE_POST_URL_STRUCTURE}

echo "populate creds file"
mkdir ~/.aws/
echo "[default]" >> ~/.aws/credentials
echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/credentials
echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/credentials
