


 kubectl exec -it devops-shared-svc-vault-0 -n vault -- vault status

 kubectl exec -it devops-shared-svc-vault-0 -n vault -- vault token lookup

 kubectl exec -it devops-shared-svc-vault-0 -n vault -- cat /vault/data/init.json 2>/dev/null

 kubectl delete pvc -n vault -l app.kubernetes.io/name=vault


 kubectl exec -it devops-shared-svc-vault-0 -n vault -- vault operator init

 kubectl delete pvc -n vault -l app.kubernetes.io/name=vault

 kubectl delete pod devops-shared-svc-vault-0 -n vault --force --grace-period=0


 kubectl exec -it devops-shared-svc-vault-0 -n vault -- vault operator init



 # Vault

 Use sidecar in the application

```
 Rotación no previene hackeo. Limita el daño.

  Si roban el secret hoy → en 1 hora ese secret ya no sirve. El atacante tiene ventana corta. Sin rotación → tienen el secret para siempre
  hasta que te des cuenta.

  ---
  Archivo compartido vs memoria — respuesta directa:
  
  Archivo en disco es peor que memoria. Persiste, es accesible por filesystem, sobrevive al proceso.

  ---
  Mejor solución: tmpfs + Vault Agent
  
  tmpfs = filesystem montado en RAM. No existe en disco. Se comporta como archivo (soporta fsnotify para rotación) pero vive solo en
  memoria.

  volumes:
  - name: vault-secrets
    emptyDir:
      medium: Memory  # <-- tmpfs, no disco

  vault-agent → escribe /vault/secrets/config.json (en RAM)
  app          → lee archivo → fsnotify para rotación
                archivo existe solo en memoria del pod
                no hay disco expuesto

  Resultado:

  ┌───────────────────────┬────────────────┬──────────────────────┬────────────────┐
  │                       │ Disco expuesto │ Rotación sin restart │ Runtime seguro │
  ├───────────────────────┼────────────────┼──────────────────────┼────────────────┤
  │ Implementación actual │ No             │ No                   │ Sí             │
  ├───────────────────────┼────────────────┼──────────────────────┼────────────────┤
  │ Archivo en disco      │ Sí             │ Sí                   │ No             │
  ├───────────────────────┼────────────────┼──────────────────────┼────────────────┤
  │ tmpfs + agent         │ No             │ Sí                   │ Sí             │
  └───────────────────────┴────────────────┴──────────────────────┴────────────────┘

  tmpfs + Vault Agent es la solución que combina todo. Es el estándar en K8s para este problema.
  ```