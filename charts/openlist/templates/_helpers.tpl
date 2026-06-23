{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openlist.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openlist.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Resolve the namespace for namespaced resources.
*/}}
{{- define "openlist.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openlist.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "openlist.labels" -}}
helm.sh/chart: {{ include "openlist.chart" . }}
app.kubernetes.io/name: {{ include "openlist.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: {{ include "openlist.name" . }}
chart: {{ include "openlist.chart" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Selector labels kept compatible with earlier chart releases.
*/}}
{{- define "openlist.selectorLabels" -}}
app: {{ include "openlist.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Name of the Secret containing the initial admin password.
*/}}
{{- define "openlist.adminSecretName" -}}
{{- default (printf "%s-admin" (include "openlist.fullname" .)) .Values.admin.existingSecret | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the PVC mounted as user file storage.
*/}}
{{- define "openlist.storageClaimName" -}}
{{- default (printf "%s-storage" (include "openlist.fullname" .)) .Values.storage.existingClaim | trunc 63 | trimSuffix "-" -}}
{{- end -}}
