#Note: Please make sure to change the IP addresses (nodes and PODS) to match your installation! 

ssh root@192.168.0.41

#Deploy a simple hello world from Google 
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0 
kubectl create deployment hello-world --image=hello-app:1.0
kubectl create deployment hello-world --image=harbor:5000/library/library/hello-app:1.0
# gcr.lank8s.cn/google-samples/hello-app:1.0
#Scale up the replica set to 4
kubectl scale --replicas=4 deployment/hello-world

#Get interfaces on this node (Node 1)
ip addr
#Show veth sets
ip link  show type veth
#Show IP-inIP
ip link show type ipip
#Get pods
kubectl get pods -o wide
#Get route to POD with IP: 172.16.94.5 (on Node1)
ip route get 172.16.94.5
#Get route to POD with IP: 172.16.94.6 (on Node 1)
ip route get 172.16.94.6

#Get route to POD with IP: 172.16.61.206 (on Node Master)
ip route get 172.16.61.206


kubectl get services

curl http://192.168.0.40:31528

kubectl get pods -o wide

#Before running the below command below, Open another terminal to the node where the POD is hosted
ssh yourID@YOUR_NODE_IP

#Start tshark (network capturing tool), you may need to install it as usually it is not included in distros by default
sudo tshark -i eth0  -V -Y "http" 

kubectl exec -it hello-world-5457b44555-5vg9f -- sh
    curl http://172.16.94.8:8080


#####################################Calico, disbale IPinIP###################################
#Imortant: You'll need to install "calicoctl" from: https://docs.projectcalico.org/getting-started/clis/calicoctl/install

sudo calicoctl node status

# pod ip address management
calicoctl get ipPool

calicoctl get ipPool default-ipv4-ippool  -o yaml > ippool.yaml

#apiVersion:projectcalico.org/v3
#kind:IPPool
#metadata:
#  creationTimestamp:"2020-11-16T15:54:37Z"
#  name:default-ipv4-ippool
#  resourceVersion:"1275"
#  uid:2e7313e8-d069-47d7-919b-41d6a126743a
#spec:
#  blockSize:26
#  cidr:172.16.0.0/16
#  ipipMode:Always
#  natOutgoing:true
#  nodeSelector:all()
#  vxlanMode:Never

#Edit the file and set ipipMode: Never
nano ippool.yaml

#To see how routes chnage after this change, first open another terminal and run:
watch route -n

#Now apply teh change
calicoctl apply -f ippool.yaml


#Start tshark (network capturing tool), you may need to install it as usually it is not included in distros by default
sudo tshark -i eth0  -V -Y "http"

kubectl exec -it hello-world-5457b44555-5vg9f -- sh
    curl http://172.16.94.8:8080
