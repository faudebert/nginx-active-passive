{{/* Return container image string from an image dict (SHA-256 takes precedence) */}}
{{- define "platform.imageStr" }}
  {{- if .sha }}
    {{- printf "%s@%s" .name .sha }}
  {{- else if .version }}
    {{- printf "%s:%s" .name .version }}
  {{- end }}
{{- end }}

{{/* Render specified file as Helm template. */}}
{{- define "platform.tplFile" }}
  {{- $ := index . 0 }}
  {{- $file := index . 1 }}
  {{- $data := index . 2 }}

  {{- tpl ($.Files.Get $file) (dict "root" $ "data" $data "Template" $.Template) }}
{{- end }}

{{/* Render files from config/$service as ConfigMap data. */}}
{{- define "platform.includeConfigs" }}
  {{- $ := index . 0 }}
  {{- $service := index . 1 }}
  {{- $data := index . 2 }}

  {{- range $path, $_ := $.Files.Glob (print "configs/" $service "/*") -}}
  {{- $tpl := include "platform.tplFile" (list $ $path $data) | indent 4 }}
  {{ base $path }}: |
{{ regexReplaceAll "[[:blank:]]*\n" $tpl "\n" }}
  {{- end }}
{{- end }}
