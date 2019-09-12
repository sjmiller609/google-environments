kubectl delete secret -n astronomer astronomer-kubed-notifier astronomer-kubed-apiserver-cert astronomer-kubed
kubectl delete serviceaccount -n astronomer astronomer-kubed
kubectl delete -n astronomer clusterroles astronomer-kubed
kubectl delete -n astronomer clusterrolebinding astronomer-kubed-apiserver-auth-delegator
kubectl delete -n astronomer clusterrolebinding astronomer-kubed
kubectl delete -n astronomer rolebinding astronomer-kubed-apiserver-extension-server-authentication-reader
kubectl delete service -n astronomer astronomer-kubed
kubectl delete deployment -n astronomer astronomer-kubed
