# Estafette CI

The resilient and cloud-native CI/CD platform.

See https://estafette.io for more information regarding the Estafette CI project.

# Installation

_Estafette CI_ can easily be installed using [Helm](https://helm.sh/).


First add the `estafette` helm repository with

```
helm repo add estafette https://helm.estafette.io
```

Although Estafette aims to have as little configuration as possible by using sane defaults the Helm chart still needs a couple of values to be set. To do so create a `values.yaml` file with the following content:

```yaml
api:
  baseHost: '<(private) host for the web gui>'
  integrationsHost: '<public host to receive webhooks>'
```

Create a namespace with

```
kubectl create namespace estafette-ci
```

Then install the `estafette-ci` chart with

```
helm upgrade --install estafette-ci estafette/estafette-ci -n estafette-ci --values values.yaml --timeout 600s
```

This should get all parts up and running, you can check with:

```
watch kubectl get svc,ing,deploy,sts,po -n estafette-ci
```

For more details on how to install and configure Estafette read the documentation at https://estafette.io/getting-started/installation/.