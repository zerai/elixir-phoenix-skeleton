#!/bin/bash
# Docker entrypoint script for dev env.


# Verify dependencies
if [ -z "$(ls -A 'deps/' 2>/dev/null)" ]; then
	mix deps.get
fi


if ! [[ -z "$POSTGRES_DB" ]]; then

    echo "Waiting for database to be ready..."
    ATTEMPTS_LEFT_TO_REACH_DATABASE=30
    until [ $ATTEMPTS_LEFT_TO_REACH_DATABASE -eq 0 ] || DATABASE_ERROR=$(MIX_ENV=dev mix ecto.migrations --no-compile 2>&1); do

        sleep 1
        ATTEMPTS_LEFT_TO_REACH_DATABASE=$((ATTEMPTS_LEFT_TO_REACH_DATABASE - 1))
        echo "Still waiting for database to be ready... Or maybe the database is not reachable. $ATTEMPTS_LEFT_TO_REACH_DATABASE attempts left."
    done

    if [ $ATTEMPTS_LEFT_TO_REACH_DATABASE -eq 0 ]; then
        echo "The database is not up or not reachable:"
        echo "$DATABASE_ERROR"
        exit 1
    else
        echo "The database is now ready and reachable"
    fi


    echo "Run database migrations for database $POSTGRES_DB"
    MIX_ENV=dev mix ecto.migrate --no-compile
    echo "Database migrations completed"
fi





exec mix phx.server
