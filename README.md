# Example of how to allow containers to run as root and/or a specific user ID.

To allow containers to run as root (or any user) you need to set the policy for the _default service account of your project_.

[Further information in the docs.](https://docs.openshift.com/container-platform/3.5/admin_guide/manage_scc.html#enable-dockerhub-images-that-require-root)

This is the simple Dockerfile we will use.  It simply builds an image and when launched, starts a long running process.

```
FROM registry.access.redhat.com/rhel-atomic
COPY somefile /tmp
#USER 1001
USER 0
ENTRYPOINT [ "/bin/bash", "-c", "id>/tmp/id;id;sleep 999999" ]
```

But first we will see what happens if we try to run a container as root on OpenShift.

## Show that containers running on OpenShift cannot run as root (by default).

```
oc login  -u demouser
oc project someproject
```

Build a new example container in OpenShift using the above example Dockerfile. Ensure the Dockerfile contains "USER 0".

```
oc new-build . --name rhel-pod       # Create a new build config
oc start-build rhel-pod --from-dir=. # Start the build, using the content of the current directory
oc logs bc/rhel-pod -f               # View the docker build logs
oc new-app rhel-pod                  # Launch a pod
oc get po
```

Remote shell (rsh) into the container and you will see it is running as non-root (not 0).

```
oc rsh <pod name>                     # Remote into the container to see which user ID it is running as. 
ps -ef 
```

Now do the same with plain docker.  You can see the container runs as root.

```
docker build -t rhel-pod .
docker run -it -d --name mycontainer rhel-pod
docker exec -it mycontainer id
```

To allow OpenShift to run containers as root, run the following as the "admin" user.

```
oc login -u admin       # Must be logged in and not just the system:admin user

oc project someproject   

oc adm policy add-scc-to-user anyuid -z default
# oc add policy add-scc-to-user anyuid system:serviceaccount:someproject:default # or the equivilent command 

oc edit scc anyuid  # verify the change 
```
Repeat the same above but using non-root user IDs, by changing the value of USER in the Dockerfile and re-building the container image. 

Example:

```
# edit the Dockerfile to switch between "USER 0" and "USER 1001"

oc start-build rhel-pod --from-dir=. # Start the build again

oc logs bc/rhel-pod -f               # View the docker build logs

oc rsh <pod>                         # Check if the container is running as root or not
```

Use the following command to explore what can be done with policies.

```
oc adm policy --help

Manage policy on pods and containers:
  add-scc-to-user                 Add users or serviceaccount to a security context constraint
  add-scc-to-group                Add groups to a security context constraint
  remove-scc-from-user            Remove user from scc
  remove-scc-from-group           Remove group from scc
```

Clean up your work with this command.  Careful, this will remove all running containers. 

```
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) 
```

