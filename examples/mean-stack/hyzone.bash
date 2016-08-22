PROJECT_NAME="app"

backend_port=8080
frontend_port=9966

mongo () {
  docker run -d $OPTS
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
    $OPTS
}

frontend () {
  docker run -d \
    -e "BACKEND_URL=localhost" \
    -v "$(pwd):/opt/app/public_html" \
    $OPTS \
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
    $OPTS


}

all () {
  hyzone run mongo
  hyzone run backend
  hyzone run frontend
}

register_container "mongo" "mongo_DOCKER_IMAGE=tutum/mongodb"
register_container "backend" "backend_DOCKER_FILE=Dockerfile.Backend"
register_container "frontend" "frontend_DOCKER_FILE=Dockerfile.Frontend"
register_container "nginx" "nginx_DOCKER_IMAGE=nginx"
register_container "all" "all_DOCKER_IMAGE=nope"
