FROM registry.access.redhat.com/rhel-atomic

COPY somefile /tmp

#EXPOSE 8080

USER 0
#USER 1001

CMD while true; do sleep 1; done

#ENTRYPOINT [ "/bin/bash", "-c", "id>/tmp/id;id;sleep 999999" ]

