DOCKER_IMAGE = googlecloud-sdk:python
AUTH_VOLUME = gcloud-config-python
DOCKER_RUN_CMD = --rm --volumes-from ${AUTH_VOLUME} -w /app -v ${CURDIR}:/app
ENV_INIT_CMD = gcloud auth login

dockerenv:
	@if [ "$$(docker ps -a | grep ${AUTH_VOLUME})" == "" ]; then \
		docker build -f Dockerfile . -t ${DOCKER_IMAGE} && \
	  docker run -ti --name ${AUTH_VOLUME} ${DOCKER_IMAGE} ${ENV_INIT_CMD}; \
	fi

bash: dockerenv
	docker run -ti ${DOCKER_RUN_CMD} ${DOCKER_IMAGE} /bin/bash

create-model: dockerenv
	docker run ${DOCKER_RUN_CMD} ${DOCKER_IMAGE} python3 src/language_entity_extraction_create_model_test.py


.PHONY: dockerenv bash dev