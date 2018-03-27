#!/bin/bash

chown -R www-data:www-data /var/www/html/sites/default/files

exec "$@"