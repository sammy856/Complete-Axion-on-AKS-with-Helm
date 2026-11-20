{{/*
Expand the name of the chart.
*/}}
{{- define "axion.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "axion.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "axion.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "axion.labels" -}}
helm.sh/chart: {{ include "axion.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: axion-platform
app.kubernetes.io/instance: {{ .Release.Name }}
environment: {{ .Values.global.environment | default "dev" }}
{{- end }}

{{/*
UI Selector labels
*/}}
{{- define "axion.ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "axion.name" . }}-ui
app.kubernetes.io/instance: {{ .Release.Name }}
app: axion-ui
{{- end }}

{{/*
UI labels
*/}}
{{- define "axion.ui.labels" -}}
{{ include "axion.labels" . }}
{{ include "axion.ui.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Telemetry Selector labels
*/}}
{{- define "axion.telemetry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "axion.name" . }}-telemetry
app.kubernetes.io/instance: {{ .Release.Name }}
app: axion-telemetry-query-service-pod
{{- end }}

{{/*
Telemetry labels
*/}}
{{- define "axion.telemetry.labels" -}}
{{ include "axion.labels" . }}
{{ include "axion.telemetry.selectorLabels" . }}
app.kubernetes.io/component: telemetry-query
{{- end }}

{{/*
Ingestion Selector labels
*/}}
{{- define "axion.ingestion.selectorLabels" -}}
app.kubernetes.io/name: {{ include "axion.name" . }}-ingestion
app.kubernetes.io/instance: {{ .Release.Name }}
app: axion-ingestion-pod
{{- end }}

{{/*
Ingestion labels
*/}}
{{- define "axion.ingestion.labels" -}}
{{ include "axion.labels" . }}
{{ include "axion.ingestion.selectorLabels" . }}
app.kubernetes.io/component: ingestion-service
{{- end }}

{{/*
Simulator Selector labels
*/}}
{{- define "axion.simulator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "axion.name" . }}-simulator
app.kubernetes.io/instance: {{ .Release.Name }}
app: axion-data-simulator
{{- end }}

{{/*
Simulator labels
*/}}
{{- define "axion.simulator.labels" -}}
{{ include "axion.labels" . }}
{{ include "axion.simulator.selectorLabels" . }}
app.kubernetes.io/component: data-simulator
{{- end }}

{{/*
PostgreSQL In-Cluster Selector labels
*/}}
{{- define "axion.postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "axion.name" . }}-postgres
app.kubernetes.io/instance: {{ .Release.Name }}
app: postgresql-server
{{- end }}

{{/*
PostgreSQL In-Cluster labels
*/}}
{{- define "axion.postgres.labels" -}}
{{ include "axion.labels" . }}
{{ include "axion.postgres.selectorLabels" . }}
app.kubernetes.io/component: database
{{- end }}

{{/*
pgAdmin In-Cluster Selector labels
*/}}
{{- define "axion.pgadmin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "axion.name" . }}-pgadmin
app.kubernetes.io/instance: {{ .Release.Name }}
app: pgadmin-pod
{{- end }}

{{/*
pgAdmin In-Cluster labels
*/}}
{{- define "axion.pgadmin.labels" -}}
{{ include "axion.labels" . }}
{{ include "axion.pgadmin.selectorLabels" . }}
app.kubernetes.io/component: db-admin
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "axion.serviceAccountName" -}}
{{- if .Values.keyvault.serviceAccount.create }}
{{- default (include "axion.fullname" .) .Values.keyvault.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.keyvault.serviceAccount.name }}
{{- end }}
{{- end }}
