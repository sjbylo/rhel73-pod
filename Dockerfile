FROM registry.access.redhat.com/rhel-atomic

COPY somefile /tmp

#EXPOSE 8080

#USER 1234
USER 0

ENTRYPOINT [ "/bin/bash", "-c", "id>/tmp/id;id;sleep 999999" ]

