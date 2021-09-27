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

Then install the `estafette-ci` chart with

```
helm upgrade --install estafette-ci estafette/estafette-ci -n estafette-ci --create-namespace --values values.yaml --timeout 600s
```

This should get all parts up and running, you can check with:

```
watch kubectl get svc,ing,deploy,sts,po -n estafette-ci
```

For more details on how to install and configure Estafette read the documentation at https://estafette.io/getting-started/installation/.

# Development

For creating a new release and it's release notes make sure you create issues for your changes in https://github.com/estafette/estafette-ci/issues. Assign the issue to yourself, and link (or create) a milestone equal to version  in the `releaseBranch` in the `.estafette.yaml` file.

If any of your updates are in one of the components referenced by the subcharts make sure to update the version in the subchart's `Chart.yaml`.

Once you've fixed and closed all issues you want to go into the next milestone then run the following commands

```
git checkout main
git pull
git checkout -b <releaseBranch>
git push origin <releaseBranch>
git checkout main
# bump the version in .estafette.yaml to the next patch and update the releaseBranch accordingly
git commit -am "bump version to 1.x.x"
git push
```

Once the version for the milestone has built release it to the `release` target at https://estafette.travix.com/pipelines/github.com/estafette/estafette-ci/overview so the github milestone gets closed, a github release gets created with release notes generated from the closed issues in the milestone.