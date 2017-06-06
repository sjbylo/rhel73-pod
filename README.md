# Example of how to allow pods to run as root and/or a specific user ID.

To allow pods to run as root (or any iser) you need to set the policy for the _default service account of your project_.
As "admin" run:

```
oc login -u admin       # Must be logged in and not just the system:admin user

oc project someproject   

oc adm policy add-scc-to-user anyuid -z default
# oc add policy add-scc-to-user anyuid system:serviceaccount:someproject:default   # The equivilent command 

oc edit scc anyuid  # verify the change 
```

## Show that containers running in OpenShift cannot run as root (by default) 

```
oc login  -u demouser
oc project someproject
```

Build a new example container in OpenShift. Ensure the Dockerfile reads USER 0

Remote shell (rsh) into the container and you can see the ID it is running as. 

```
oc new-build . --name rhel73-bash
oc start-build rhel73-bash --from-dir=.
oc logs bc/rhel73-bash -f
oc new-app rhel73-bash
oc get po
oc rsh <pod name> 
ps -ef 
```

Now do the same with plain docker.  You can see the conatiner runs as root.

```
docker build -t rhel73-bash .
docker run -it -d --name mycontainer rhel73-bash
docker exec -it mycontainer id
```

Repeat the same above but using non-root user IDs, by changing the value of USER in the Dockerfile. 

Run the following command to explore the policies set

```
oc adm policy --help

Manage policy on pods and containers:
  add-scc-to-user                 Add users or serviceaccount to a security context constraint
  add-scc-to-group                Add groups to a security context constraint
  remove-scc-from-user            Remove user from scc
  remove-scc-from-group           Remove group from scc
```

Clean up with this command.  Careful, this will remove all running containers. 

```
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) 
```
