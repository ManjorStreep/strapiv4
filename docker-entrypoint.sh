#!/bin/sh
set -ea

if [ "$1" = "yarn" ]; then

  # Fix permissions for /srv/app
  chown -R node:node /srv/app

  if [ ! -f "package.json" ]; then

    DATABASE_CLIENT=${DATABASE_CLIENT:-sqlite}

    EXTRA_ARGS=${EXTRA_ARGS}

    echo "Using strapi $(strapi version)"
    echo "No project found at /srv/app. Creating a new strapi project"

    # Run strapi new as node user
    su-exec node:node strapi new . \
      --dbclient=$DATABASE_CLIENT \
      --dbhost=$DATABASE_HOST \
      --dbport=$DATABASE_PORT \
      --dbname=$DATABASE_NAME \
      --dbusername=$DATABASE_USERNAME \
      --dbpassword=$DATABASE_PASSWORD \
      --dbssl=$DATABASE_SSL \
      $EXTRA_ARGS

  elif [ ! -d "node_modules" ] || [ ! "$(ls -qAL node_modules 2>/dev/null)" ]; then

    echo "Node modules not installed. Installing..."

    if [ -f "yarn.lock" ]; then

      su-exec node:node yarn install

    else

      su-exec node:node npm install

    fi

  fi

fi

echo "Starting your app..."

# Exec command as node user
exec su-exec node:node "$@"