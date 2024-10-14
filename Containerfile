FROM ghcr.io/ublue-os/fedora-distrobox:latest

LABEL com.github.containers.toolbox="true" \
  usage="This image is meant to be used with the toolbox or distrobox command" \
  summary="An image to run as a development environment and default shell" \
  maintainer="me@rosswilliams.id.au"

# `yq` is used for parsing the yaml configuration
# It is copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq:4.40.3 /usr/bin/yq /usr/bin/yq
COPY files /tmp/files/
RUN chmod +x /tmp/files/build.sh && \
  /tmp/files/build.sh && \
  rm -rf /tmp/files && \
  ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
  ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open

