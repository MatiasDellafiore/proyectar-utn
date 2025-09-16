# ProyectAR - Manual rápido

## Prerrequisitos
- Acceso SSH al servidor: `ssh proyecto1@vps1.disilab.cpci.org.ar`
- Traefik corriendo en la red externa `web` (provista por infraestructura)
- Dominio: `https://proyectar.labo.disilab.cpci.org.ar`

## 1) Desplegar
Desde el directorio del proyecto:
```bash
./deploy.sh
```
Qué hace `deploy.sh`:
- Verifica conexión SSH y que el dominio resuelva
- Sube archivos a `~/proyectar` en el servidor
- En el servidor: `docker-compose down`, build, `docker-compose up -d`
- Muestra estado (`docker-compose ps`) y logs recientes

## 2) Verificar que funciona
```bash
./verify.sh
```
Qué hace `verify.sh`:
- Verifica SSH
- Chequea contenedor `running (healthy)`
- Comprueba DNS del dominio
- Hace request HTTPS y espera HTTP 200
- Muestra logs recientes (app y Traefik si aplica)

## 3) Comprobación manual (opcional)
- Navegador: `https://proyectar.labo.disilab.cpci.org.ar`
- Terminal:
```bash
curl -I https://proyectar.labo.disilab.cpci.org.ar
```
Deberías ver `HTTP/2 200`.

## 4) Debug rápido
En el servidor:
```bash
ssh proyecto1@vps1.disilab.cpci.org.ar
cd ~/proyectar
# Estado
docker-compose ps
# Logs de la app
docker-compose logs -f
# Reiniciar
docker-compose restart
```
Logs de Traefik (si hace falta):
```bash
ssh proyecto1@vps1.disilab.cpci.org.ar
cd /home/ahk/traefik
docker-compose logs -f traefik
```

## 5) Detener/cerrar el servicio
- Desde tu máquina (vía SSH en un solo comando):
```bash
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose down'
```
- O dentro del servidor:
```bash
ssh proyecto1@vps1.disilab.cpci.org.ar
cd ~/proyectar
docker-compose down
```

## Detalles técnicos
- Traefik: labels en `docker-compose.yml` configuran el router `proyectar` sobre `websecure` (HTTPS) con TLS y `leresolver`
- La app Next.js sirve en puerto 3000; Traefik enruta por host `proyectar.labo.disilab.cpci.org.ar`
- Healthcheck: `GET /api/health` responde `{ "status": "ok" }`; Docker lo usa para marcar `healthy`

## Desde otra máquina (con credenciales)
- Desplegar: `./deploy.sh`
- Verificar: `./verify.sh`
- Acceder: navegador o `curl -I https://proyectar.labo.disilab.cpci.org.ar`
