ARG from=ubuntu

FROM $from

ARG user=niko
ARG uid=1000

run useradd --create-home --user-group --shell /bin/bash --uid $uid $user

USER $user

WORKDIR /home/$user/

ENV PATH="/home/$user/.local/bin/:$PATH"

CMD /bin/bash
