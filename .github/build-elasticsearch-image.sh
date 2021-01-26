docker image build \
    --tag ${DOCKER_USERNAME}/elasticsearch:${DOCKER_ELASTICSEARCH_IMAGE_TAG} \
    --no-cache \
    --compress \
    -f project-base/docker/elasticsearch/Dockerfile \
    . &&
docker image push ${DOCKER_USERNAME}/elasticsearch:${DOCKER_ELASTICSEARCH_IMAGE_TAG}
