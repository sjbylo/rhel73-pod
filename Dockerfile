FROM registry.access.redhat.com/rhel-atomic

MAINTAINER Stephen Bylo <sbylo@redhat.com>

COPY somefile /tmp

#EXPOSE 8080

#USER 1001
USER 0

ENTRYPOINT [ "/bin/bash", "-c", "id>/tmp/id;id;sleep 999999" ]

