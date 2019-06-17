{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pgpool-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pgpool-helm.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "pgpool-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Find stolon namespace
*/}}
{{- define "pgpool-helm.stolon" -}}
{{- printf .Release.Namespace | replace (include "pgpool-helm.name" .) .Values.namespace.stolon -}}
{{- end -}}
{{/*
Generate default backend for github.com/lwolf/stolon-chart
*/}}
{{- define "pgpool-helm.makeBackends" -}}
{{- printf "0:%s-proxy.%s::::ALWAYS_MASTER,1:%s-keeper-headless.%s::::DISALLOW_TO_FAILOVER" (include "pgpool-helm.stolon" .) (include "pgpool-helm.stolon" .) (include "pgpool-helm.stolon" .) (include "pgpool-helm.stolon" .) -}}
{{- end -}}
