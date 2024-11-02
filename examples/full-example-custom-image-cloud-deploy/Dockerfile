FROM ghcr.io/runatlantis/atlantis:v0.30.0-alpine

USER root

# Copy repository config
COPY ./repos.yaml /app/repos.yaml

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install other tools

USER atlantis

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["server"]
