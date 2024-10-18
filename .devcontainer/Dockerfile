# Note: bootstrap scripts are copied in from this repo, but the dotfiles are pulled from the repo 'dev' branch
FROM mcr.microsoft.com/devcontainers/base:debian
USER vscode
WORKDIR /home/vscode
ENV USER=vscode
CMD ["/usr/bin/zsh"]

RUN mkdir .mh-bootstrap
COPY bootstrap/install-for-linux.sh .mh-bootstrap
RUN bash .mh-bootstrap/install-for-linux.sh

# Allow rebuilding the image to just update dependencies, rather than re-installing everything
ARG CACHEBUST=default
COPY bootstrap/refresh-for-new-container.sh .mh-bootstrap
RUN bash .mh-bootstrap/refresh-for-new-container.sh --cachebust "${CACHEBUST}"
