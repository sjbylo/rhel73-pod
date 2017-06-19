FROM registry.access.redhat.com/rhel-atomic

COPY somefile /tmp

#EXPOSE 8080

USER 1001
#USER 0

ENTRYPOINT [ "/bin/bash", "-c", "id>/tmp/id;id;sleep 999999" ]

#CMD while true; do sleep 1; done

