# Note: install script is copied in from this repo, but the dotfiles are pulled from the repo 'dev' branch. TODO: make this more flexible
FROM mcr.microsoft.com/devcontainers/base:debian
USER vscode
WORKDIR /home/vscode
COPY install-for-linux.sh .
ENV USER=vscode
RUN bash install-for-linux.sh
RUN rm install-for-linux.sh
CMD ["/usr/bin/zsh"]

# Allow rebuilding the image to just update dependencies, rather than re-installing everything
ARG CACHEBUST
RUN ["/usr/bin/zsh", "-i", "-c", "chezmoi update --init --force"]
RUN ["/usr/bin/zsh", "-i", "-c", "mh-install"]
