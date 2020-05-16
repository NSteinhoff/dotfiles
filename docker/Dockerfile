ARG from=ubuntu

FROM $from

ARG user=niko
ARG uid=1000

RUN useradd --create-home --user-group --shell /bin/bash --uid $uid $user

USER $user
ENV HOME="/home/$user"

WORKDIR "$HOME"

RUN mkdir -p "$HOME/.local/bin"

ENV PATH="$HOME/.local/bin:$PATH"

CMD ["/bin/bash"]
