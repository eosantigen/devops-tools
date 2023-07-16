# Use Raw template formatting
```
shell: docker images {{ docker_registry__demo }}/test-{{ app }} --format={%raw %}'{{ .CreatedAt }}'{% endraw %} --format={%raw %}'{{ .Tag }}'{% endraw %} | sort | tail -n 1 | awk $1 '{print $1}'
```
