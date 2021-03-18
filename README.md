# Estafette CI

The resilient and cloud-native CI/CD platform.

See https://estafette.io for more information regarding the Estafette CI project.

# Installation

In order to give Estafette CI a test drive you can install it using the Helm chart.

First add the `estafette` helm repository with

```
helm repo add estafette https://helm.estafette.io
```

Then install the `estafette-ci` chart with

```
helm upgrade --install estafette-ci estafette/estafette-ci -n estafette-ci --timeout 600s
```

With Estafette CI making use of CockroachDB in **secure mode** you need to approve one or more _certificate signing requests_ by doing the following while the installation runs (and before it times out):

```
kubectl get csr
```

You will see one or more csr's and will have to approve this with (for example):

```
kubectl certificate approve estafette-ci.client.root
kubectl certificate approve estafette-ci.node.estafette-ci-db-0
kubectl certificate approve estafette-ci.node.estafette-ci-db-1
kubectl certificate approve estafette-ci.node.estafette-ci-db-2
```

# Configuration

In order to get things to run correctly you'll have pass configuration to the `helm install/upgrade` command by passing `-f my-values.yaml`.

## Database

To configure the _CockroachDB_ cluster set the following in `my-values.yaml`:

```yaml
db:
  statefulset:
    replicas: 3
  storage:
    persistentVolume:
      enabled: true
      size: 50Gi
  ingress:
    enabled: true
    paths: ['/']
    hosts:
    - estafette-ci-db.mydomain.com
```

For more information on configuring the _CockroachDB_ helm chart take a look at its [values file](https://github.com/cockroachdb/helm-charts/blob/master/cockroachdb/values.yaml).

## Api & web ui

To configure the api part and access to the web ui add the following to `my-values.yaml`:

```yaml
api:
  secret:
    files:
      # the aes-256 key to encrypt/decrypt estafette secrets
      secretDecryptionKey: <generate a 256 bit encryption key, it's used to encrypt estafette secrets>

  config:
    files: |
      config.yaml: |
        apiServer:
          baseURL: https://estafette-ci.mydomain.com

        auth:
          jwt:
            domain: estafette-ci.mydomain.com
            key: <some random generated string>
          administrators:
          - <your email>
          organizations:
          - name: <an organization name you can decide on yourself>
            oauthProviders:
            - name: google
              clientID: <a google aouth credential client id>
              clientSecret: <a google aouth credential client id>
              allowedIdentitiesRegex: <a regular expression to limit access to users of your domain, let's say .+@mydomain\.com>

        database:
          databaseName: defaultdb
          user: root

        credentials:
        - name: container-registry-estafette
          type: container-registry
          repository: <your docker hub or gcr registry>
          private: false
          username: <username for accessing the docker registry>
          password: <access token for accessing the docker registry>

  ingress:
    enabled: true
    hosts:
      - host: estafette-ci.mydomain.com
        paths:
        - path: /api/
          pathType: Prefix
          backend:
            service:
              name: estafette-ci-api
              port:
                name: http
        - path: /
          pathType: Prefix
          backend:
            service:
              name: estafette-ci-web
              port:
                name: http
```

For more information on configurating the _estafette-ci-api_ Helm chart check its [values file](https://github.com/estafette/estafette-ci-api/blob/main/helm/estafette-ci-api/values.yaml).

# TODO

- create users in cockroachdb and client certificates
- add estafette-ci-db-migrator
- set more sensible defaults in estafette config so less needs to be passed
- add estafette-ci-cron-event-sender and allow pre-creation of a client id through config
- allow for login-less usage to just test estafette
- document how to set up github/bitbucket integration, or somehow automate this
- disable jaeger by default