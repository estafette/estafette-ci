# Estafette CI

The resilient and cloud-native CI/CD platform.

See https://estafette.io for more information regarding the Estafette CI project.

# Installation

In order to give Estafette CI a test drive you can install it using the Helm chart.

First add the `estafette` helm repository with

```
helm repo add estafette https://helm.estafette.io
```

Then create the following `my-values.yaml` file:

```yaml
api:
  config:
    files: |
      config.yaml: |
        apiServer:
          baseURL: https://estafette-ci.mydomain.com
          integrationsURL: https://estafette-ci-webhooks.mydomain.com

        auth:
          jwt:
            domain: estafette-ci.mydomain.com
```

Then install the `estafette-ci` chart with

```
helm upgrade --install estafette-ci estafette/estafette-ci -n estafette-ci --values my-values.yaml --timeout 600s
```

# Configuration

In order to get things to run as desired you'll have pass configuration to the `helm install/upgrade` command by passing `--values my-values.yaml`.

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
          integrationsURL: https://estafette-ci-webhooks.mydomain.com

        auth:
          jwt:
            domain: estafette-ci.mydomain.com
          administrators:
          - <your email>
          organizations:
          - name: <an organization name you can decide on yourself>
            oauthProviders:
            - name: google
              clientID: <a google aouth credential client id>
              clientSecret: <a google aouth credential client id>
              allowedIdentitiesRegex: <a regular expression to limit access to users of your domain, let's say .+@mydomain\.com>

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

  ingressWebhooks:
    enabled: true
    hosts:
      - host: estafette-ci-webhooks.mydomain.com
        paths:
        - path: /api/integrations/github
          pathType: Prefix
          backend:
            service:
              name: estafette-ci-api
              port:
                name: http
        - path: /api/integrations/bitbucket
          pathType: Prefix
          backend:
            service:
              name: estafette-ci-api
              port:
                name: http
```

For more information on configurating the _estafette-ci-api_ Helm chart check its [values file](https://github.com/estafette/estafette-ci-api/blob/main/helm/estafette-ci-api/values.yaml).

# TODO

- allow for login-less usage to just test estafette
- document how to set up github/bitbucket integration, or somehow automate this
- disable jaeger by default