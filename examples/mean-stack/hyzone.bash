PROJECT_NAME="app"

backend_port=8080
frontend_port=9966

backend_dockerfile="Dockerfile.Backend"
frontend_dockerfile="Dockerfile.Frontend"

mongo () {
  docker run -d $HYZONE_OPTS tutum/mongodb
}

backend () {
  mongo_url="mongodb://$(hyzone ip mongo):27017/myproject"

  if [ -z "$mongo_url" ]; then
    echo "Cannot get mongo url"
    exit 1
  fi

  docker run -d \
    -e "BACKEND_PORT=$backend_port" \
    -e "MONGO_URL=$mongo_url" \
    $HYZONE_OPTS
}

frontend () {
  docker run -d \
    -e "BACKEND_URL=localhost" \
    -v "$(pwd):/opt/app/public_html" \
    $HYZONE_OPTS \
    index.js
}

nginx () {

  rm nginx.conf.tmp || true
  cp nginx.conf nginx.conf.tmp
  sed -i "s/\$frontend_port/$frontend_port/" nginx.conf.tmp
  sed -i "s/\$backend_port/$backend_port/" nginx.conf.tmp

  docker run -d \
    -v /data:/usr/share/nginx/html:ro \
    -v $(pwd)/nginx.conf.tmp:/etc/nginx/nginx.conf:ro \
    $HYZONE_OPTS \
    nginx


}

all () {
  hyzone run mongo
  hyzone run backend
  hyzone run frontend
}

