echo "###### set env vars ############"
ENV=dev
POSTGRES_USER=phx_hiverec_$ENV
POSTGRES_PASSWORD=phx_hiverec_$ENV
POSTGRES_DATABASE=phx_hiverec_$ENV
DB_CONTAINER=hiverec-postgres

export DATABASE_URL=ecto://$POSTGRES_USER:$POSTGRES_PASSWORD@$DB_CONTAINER/$POSTGRES_DATABASE
export SECRET_KEY_BASE=JN86z04sY+FBL0PzjZT2ODlnKKZgVXNy7NHEfW1jgJSgzJKAOhjWJcwWPt/wWqcx

echo "###### start composer ############"
docker compose up -d
sleep 2

echo "###### create postres user ############"
docker exec -ti $DB_CONTAINER psql -U postgres -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD' CREATEDB;"

echo "###### create postres database ############"
docker exec -ti $DB_CONTAINER psql -U postgres -c "CREATE DATABASE $POSTGRES_DATABASE OWNER $POSTGRES_USER;"

echo "###### ecto migrate ############"
docker exec -it hiverec-app bin/hiverec eval "Hiverec.Release.migrate"

echo "###### check db access ############"
docker exec -ti $DB_CONTAINER psql -U $POSTGRES_USER -c "select id,login,email from users;"

echo "###### check running containers ############"
docker ps | grep hiverec

echo "###### compose logs ############"
docker compose logs

echo "###### stop composer ############"
echo -n "docker compose down? [Y] "; read answer
docker compose down
