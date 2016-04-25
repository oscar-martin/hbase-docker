#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the hbase-docker container
#
# hbase thrift and master server logs are written to the local
# logs directory
#
#set -x

LOCAL_VM_NAME=${DOCKER_MACHINE_NAME}
HBASE_HOST_NAME="hbase-docker"

IP=$(docker-machine ip ${LOCAL_VM_NAME})

echo "Updating /etc/hosts to make ${HBASE_HOST_NAME} point to ${IP} locally"
if grep "${HBASE_HOST_NAME}" /etc/hosts >/dev/null; then
  sudo sed -i '' "s/^.*${HBASE_HOST_NAME}.*\$/${IP} ${HBASE_HOST_NAME}/" /etc/hosts
else
  sudo sh -c "echo '${IP} ${HBASE_HOST_NAME}' >> /etc/hosts"
fi

echo "Updating /etc/hosts to make ${HBASE_HOST_NAME} point to ${IP} in docker-machine"
if docker-machine ssh "${LOCAL_VM_NAME}" "grep '${HBASE_HOST_NAME}' /etc/hosts >/dev/null"; then
  eval $(docker-machine ssh "${LOCAL_VM_NAME}" "sudo sed -i 's/^.*${HBASE_HOST_NAME}.*\$/${IP} ${HBASE_HOST_NAME}/' /etc/hosts")
else
  docker-machine ssh "${LOCAL_VM_NAME}" "sudo sh -c \"echo '${IP} ${HBASE_HOST_NAME}' >> /etc/hosts\""
fi

echo "Execute: docker-compose up -d"
