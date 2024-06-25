#!/bin/bash

echo "[LAUNCH] Open Targets Genetics Portal API"
docker run -d \
  -p ${API_PORT}:${API_PORT} \
  --log-driver=gcplogs \
  -e SLICK_CLICKHOUSE_URL='${SLICK_CLICKHOUSE_URL}' \
  -e ELASTICSEARCH_HOST='${ELASTICSEARCH_HOST}' \
  -e DATA_MAJOR='${DATA_MAJOR}' \
  -e DATA_MINOR='${DATA_MINOR}' \
  -e DATA_PATCH='${DATA_PATCH}' \
  quay.io/opentargets/genetics-api:${API_VERSION}
