{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "estafette-ci-hanging-job-cleaner.name" -}}
{{- default .Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "estafette-ci-hanging-job-cleaner.fullname" -}}
{{- if $.Values.fullnameOverride -}}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name $.Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "estafette-ci-hanging-job-cleaner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "estafette-ci-hanging-job-cleaner.labels" -}}
app.kubernetes.io/name: {{ include "estafette-ci-hanging-job-cleaner.name" . }}
helm.sh/chart: {{ include "estafette-ci-hanging-job-cleaner.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- range $key, $value := $.Values.extraLabels }}
{{ $key }}: {{ $value }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "estafette-ci-hanging-job-cleaner.serviceAccountName" -}}
{{- if $.Values.serviceAccount.create -}}
    {{ default (include "estafette-ci-hanging-job-cleaner.fullname" .) $.Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" $.Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the tag of the image to use
*/}}
{{- define "estafette-ci-hanging-job-cleaner.imageTag" -}}
{{ default .Chart.AppVersion $.Values.image.tag }}
{{- end -}}

{{/*
Create the namespace for build/release jobs
*/}}
{{- define "estafette-ci-hanging-job-cleaner.jobNamespace" -}}
{{- if $.Values.jobNamespaceOverride }}
{{- $.Values.jobNamespaceOverride }}
{{- else }}
{{- .Release.Namespace }}-jobs
{{- end }}
{{- end }}
