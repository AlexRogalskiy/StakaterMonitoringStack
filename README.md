# Monitoring Stack
A Stack to deploy Monitoring Stack on Kubernetes Cluster via Helm Charts i.e. Prometheus Operator, Prometheus, Grafana, AlertManager, Node Exporter, Kube State Metrics.

[Prometheus Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) chart is being use for the monitoring stack deployment.

# Changes for a new Deployment
* Change the values of these according to your `domain`:
  1. `config.xposer.domain.com/domain` in Xposer annotations for every service
  2. `config.xposer.domain.com/IngressURLTemplate` in Xposer annotations for every service
  3. `values->grafana->ingress->hosts` in `monitoringHelmRelease.yaml`
  4. `values->xposer->config->domain` in `xposerHelmRelease.yaml`


# How to deploy
1. Make sure `kubectl` is configured correctly with your kubernetes cluster. i.e. `~/.kube/config`
2. Create a new namespace in the cluster
```
kubectl create namespace monitoring
```
3. Switch directory to `manifests` folder
```
cd manifests
```
4. Run the following command
```
kubectl apply -f . -n monitoring
```

5. Run the following command
```
kubectl apply -f . -n monitoring
```
6. It will take 3-4 minutes for kubernetes to completely reflect all the changes on the dasboard.

# Grafana Dashoboards
Deploy Grafana dashobards as following:
```
cd manifests/grafanaDashboards/
kubectl apply -f . -n monitoring
```
## Grafana Additional Charts

* First add the chart in the grafana chart by using the `chart id`.
* Export the chart as a json manifest.
* Create a file with this format:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-health
  labels:
    grafana_dashboard: "1"
    app: domain-grafana
    
    chart: prometheus-operator-5.0.13
    release: "domain-monitoring"
    heritage: "Tiller"
    expose: "true"
data:
   
  cluster-health.json: |-
    <add the new dashboard manifest(json based) here>
```
* Add the new dashboard by using the command given below:
```bash
$ sudo kubectl apply -f <dashboard-manifest>.yaml -n <namesapce-name>
```
* Check the grafana dashboard for new dashboard.

# How to redeploy the monitoring stack

This section will provide guidelines on how to redeploy the monitoring stack

* Delete the monitoring stack deployment using the command given below:
```bash
$ sudo kubectl delete -f monitoringKubeHelmRelease.yaml -n monitoring
```

* Delete the respective CRDS given on [prometheus-operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator) helm chart repository.

* Redeploy the monitoring stack using the command given below:
```bash
$ sudo kubectl apply -f monitoringKubeHelmRelease.yaml -n monitoring
```

* Open the monitoring namespace UI to check whether deployments, pods, services and ingresses are created or not.

* Ingress of Alertmanager, grafana and prometheus must be created.

* Also look at the logs of helm operator.

* Run the command given below to check chart's deployment status, it must be in deployed state:
```bash
$ sudo helm ls --namespace monitoring
```

# Templatizing the chart
To templatize the chart with values use the command given below:

```
$ sudo helm template . -f testing-new-val.yaml > testing-new-val-template.yaml
```
It will use the values given in `testing-new-val.yaml` file to generate `testing-new-val-template.yaml` file

# For Issues
In case of any issue go through the guidelines provided on this [link](https://github.com/helm/charts/tree/master/stable/prometheus-operator)

