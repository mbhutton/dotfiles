FROM mcr.microsoft.com/devcontainers/base:debian
USER vscode
WORKDIR /home/vscode
COPY install-for-linux.sh .
ENV USER=vscode
# ENV SHELL=/usr/bin/zsh
RUN bash install-for-linux.sh
RUN rm install-for-linux.sh
# RUN bash -c '[[ "$SHELL" != "$(which zsh)" ]] && (sudo chsh -s "$(which zsh)" "$USER")'

# Change shell as sudo to avoid password prompt. TODO:veriy this is necessary
RUN sudo chsh -s "$(which zsh)" "$USER"
CMD ["/usr/bin/zsh", "-i"]
# TODO fix this file
# ENTRYPOINT ["/usr/bin/zsh", "-i", "-c"]
# To build (from dotfiles dir): docker build -t blah-tag -f .devcontainer/Dockerfile .
#   Add this to just
# Note: Lots of caching happening now!
