Probando y desplegando la política de privacidad (nginx + Docker)

Este pequeño README explica cómo buildear y probar localmente la imagen Docker y qué revisar si Coolify muestra `Bad Gateway`.

1) Construir la imagen localmente (PowerShell):

```powershell
# Desde la carpeta del proyecto
docker build -t macod-privacidad:latest .
```

2) Ejecutar la imagen localmente:

```powershell
docker run --rm -p 8080:8080 --name macod-privacidad macod-privacidad:latest
# Abrir http://localhost:8080 en el navegador
```

3) Comprobaciones si aparece "Bad Gateway" en Coolify:

- Verifica los logs del contenedor (Coolify / panel del servicio) y busca errores de nginx o fallos de arranque.
- Asegúrate de que el contenedor responde en el puerto 80 internamente. El Dockerfile expone el puerto 80 y la configuración de nginx escucha en `0.0.0.0:80`.
- Coolify (o el proxy que uses) normalmente hará healthchecks al endpoint interno. Añadimos un HEALTHCHECK para que la plataforma espere a que el contenedor sirva antes de enrutar tráfico.
- Revisa que en la configuración de tu servicio en Coolify el puerto objetivo sea 80 y que no haya reglas de routing que cambien el host o path.

- Revisa que en la configuración de tu servicio en Coolify el puerto objetivo sea 8080 y que no haya reglas de routing que cambien el host o path.

4) Troubleshooting avanzado:

- Ejecuta `docker run -it --rm macod-privacidad:latest sh` y dentro del contenedor ejecuta `wget -q -O - http://127.0.0.1/` para comprobar que nginx responde.
- Revisa permisos de archivos copiados a `/usr/share/nginx/html`. Nginx necesita permisos de lectura.
- Si el contenedor vuelve a reiniciarse, revisa los últimos logs con `docker logs <container>`.

Nota: He añadido un archivo `health.html` en la raíz del sitio con contenido simple `OK`. El HEALTHCHECK usa la raíz (`/`) por defecto; si prefieres que el HEALTHCHECK apunte a `/health.html` explícitamente, dímelo y lo actualizo en el `Dockerfile`.

Si quieres, puedo añadir un endpoint /health simple (archivo HTML) o ajustar la política de cache según tus necesidades. También puedo reproducir localmente el build y ejecutar el contenedor si autorizas que use el terminal en esta sesión.
