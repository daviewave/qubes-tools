#!/bin/bash

set -ex

# 1, ensure at least 1 argument is passed in
if [ $# -lt 1 ]; then
    echo "Usage: $0 CONTAINER_ENGINE <MOCK_CONFIGURATION_FILE>" >&2
    echo "If MOCK_CONFIGURATION_FILE is provided, it will use Mock chroot as container rootfs." >&2
    exit 1
fi

CONTAINER_ENGINE="$1" 	# docker or podman
DOCKERFILE_OS="$2"	# dockerfile to fetch (debian, fedora, fedora-mock, ubuntu)
MOCK_CONF="$3" 		# optional mock config file
TOOLS_DIR="$(dirname "$0")"
TOOLS_DIR="$(readlink -f "$TOOLS_DIR")"

# ensure docker or podman passed as arguement
[ -n "$CONTAINER_ENGINE" ] || {
    echo "Please provide container engine: 'docker' or 'podman'."
    exit 1
}
if [ "$CONTAINER_ENGINE" != "docker" ] && [ "$CONTAINER_ENGINE" != "podman" ]; then
    echo "Only 'docker' and 'podman' are supported."
    exit 1
fi

# get dockerfile
if [ -z "$DOCKERFILE_OS" ]; then
    echo "HITTTING"
    DOCKERFILE_OS="fedora"
fi
DOCKERFILE="${TOOLS_DIR}/../dockerfiles/$DOCKERFILE_OS.Dockerfile"
echo "DOCKERFILE: $DOCKERFILE"

# sets the container cmd argument
if [ "$CONTAINER_ENGINE" == "docker" ]; then
    #CONTAINER_CMD="sudo docker"
    CONTAINER_CMD="docker"
else
    CONTAINER_CMD="podman"
fi


# determine run command based on mock conf passed in then run it
if [ -n "$MOCK_CONF" ]; then
    MOCK_CONF_BN="$(basename "$MOCK_CONF")"

    # Remove chroot and cache
    sudo mock \
        -r "$MOCK_CONF" \
        --scrub=all

    # Create Mock chroot cache
    sudo mock \
        -r "$MOCK_CONF" \
        --init \
        --no-bootstrap-chroot \
        --config-opts chroot_setup_cmd='install dnf @buildsys-build'

    # Create Docker image
    # FIXME: The trim of .cfg extension does not work if rawhide is provided implicitly
    #  like at the time of writing 'fedora-37-x86_64'. We need to find a more reliable way
    #  to obtain mock chroot name.

    $CONTAINER_CMD build \
	-f "$DOCKERFILE" \
        -t "qubes-builder-$DOCKERFILE_OS" \
        "/var/cache/mock/${MOCK_CONF_BN%.cfg}/root_cache/"
else
    $CONTAINER_CMD build \
        -f "$DOCKERFILE" \
        -t "qubes-builder-$DOCKERFILE_OS" .
fi
