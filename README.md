# 🚀 ProyectAR - Integración con Infraestructura UTN

Este repositorio contiene la configuración para integrar ProyectAR con la infraestructura de la facultad UTN, utilizando Docker y Traefik como reverse proxy.

## 📋 Prerrequisitos

- Acceso SSH al servidor `vps1.disilab.cpci.org.ar`
- Clave SSH privada configurada
- Docker y Docker Compose instalados en el servidor
- Dominio `proyectar.labo.disilab.cpci.org.ar` configurado

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Traefik       │    │   ProyectAR      │    │   MongoDB       │
│   (Reverse      │────│   (Next.js App)  │────│   (Database)    │
│    Proxy)       │    │   Port: 3000     │    │   Port: 27017   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │
         │ HTTPS
         │
┌─────────────────┐
│   Usuario       │
│   (Browser)     │
└─────────────────┘
```

## 📁 Estructura del Proyecto

```
proyectar-utn/
├── docker-compose.yml    # Configuración de servicios Docker
├── Dockerfile           # Imagen Docker para ProyectAR
├── deploy.sh           # Script de deployment automatizado
├── test-page.tsx       # Página de prueba simple
└── README.md           # Esta documentación
```

## 🔧 Configuración

### 1. Docker Compose

El archivo `docker-compose.yml` define dos servicios:

- **proyectar**: La aplicación Next.js con labels de Traefik
- **mongo**: Base de datos MongoDB (no expuesta públicamente)

### 2. Labels de Traefik

Los labels configuran el routing y SSL:

```yaml
labels:
  - 'traefik.enable=true'
  - 'traefik.docker.network=web'
  - 'traefik.http.routers.proyectar.entrypoints=websecure'
  - "traefik.http.routers.proyectar.rule=Host(`proyectar.labo.disilab.cpci.org.ar`)"
  - "traefik.http.routers.proyectar.tls=true"
  - "traefik.http.routers.proyectar.tls.certresolver=leresolver"
```

### 3. Red Externa

Todos los servicios están conectados a la red `web` externa de Traefik:

```yaml
networks:
  web:
    external: true
```

## 🚀 Deployment

### Opción 1: Script Automatizado (Recomendado)

```bash
./deploy.sh
```

El script automatiza todo el proceso:
1. Verifica la conexión SSH
2. Crea directorios necesarios
3. Sube archivos al servidor
4. Construye y despliega la aplicación

### Opción 2: Manual

```bash
# 1. Subir archivos
scp docker-compose.yml Dockerfile proyecto1@vps1.disilab.cpci.org.ar:~/proyectar/

# 2. Conectar al servidor
ssh proyecto1@vps1.disilab.cpci.org.ar

# 3. Navegar al directorio
cd ~/proyectar

# 4. Detener servicios existentes
docker-compose down

# 5. Construir nueva imagen
docker-compose build --no-cache

# 6. Iniciar servicios
docker-compose up -d
```

## 🔍 Verificación

### 1. Estado de los Contenedores

```bash
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose ps'
```

### 2. Logs de la Aplicación

```bash
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose logs -f proyectar'
```

### 3. Logs de Traefik

```bash
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd /home/ahk/traefik && docker-compose logs -f traefik'
```

### 4. Acceso Web

Visita: https://proyectar.labo.disilab.cpci.org.ar

## 🛠️ Comandos Útiles

### Gestión de Servicios

```bash
# Iniciar servicios
docker-compose up -d

# Detener servicios
docker-compose down

# Reiniciar servicios
docker-compose restart

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f proyectar
```

### Debugging

```bash
# Ver estado de contenedores
docker-compose ps

# Entrar al contenedor
docker-compose exec proyectar sh

# Ver uso de recursos
docker stats

# Limpiar contenedores e imágenes
docker-compose down --rmi all --volumes --remove-orphans
```

## 🔧 Troubleshooting

### Error de Conexión SSH

```bash
# Verificar configuración SSH
ssh -v proyecto1@vps1.disilab.cpci.org.ar

# Verificar clave SSH
ssh-add -l
```

### Error de Dominio

```bash
# Verificar resolución DNS
ping proyectar.labo.disilab.cpci.org.ar

# Verificar conectividad
curl -I https://proyectar.labo.disilab.cpci.org.ar
```

### Error de Traefik

```bash
# Ver logs de Traefik
cd /home/ahk/traefik
docker-compose logs -f traefik

# Verificar configuración de red
docker network ls
docker network inspect web
```

### Error de Aplicación

```bash
# Ver logs de la aplicación
docker-compose logs -f proyectar

# Verificar que el puerto esté expuesto
docker-compose exec proyectar netstat -tlnp
```

## 📊 Monitoreo

### Health Check

La aplicación incluye un health check que verifica:
- Disponibilidad del puerto 3000
- Respuesta del endpoint `/api/health`

### Logs

Los logs se almacenan en:
- Aplicación: `./data/logs/`
- MongoDB: `./data/mongo/`
- Uploads: `./data/uploads/`

## 🔐 Seguridad

### Variables de Entorno

Las variables sensibles se configuran en el `docker-compose.yml`:

```yaml
environment:
  - NODE_ENV=production
  - JWT_SECRET=your-super-secure-jwt-secret-for-production
  - MONGODB_URI=mongodb://mongo:27017/proyectar
```

### Redes

- La aplicación está en la red `web` (pública)
- MongoDB está solo en la red `web` (no expuesto)
- Traefik maneja el SSL/TLS automáticamente

## 📈 Próximos Pasos

1. **Configurar dominio real**: Cambiar a `proyectar.edu.ar`
2. **Implementar CI/CD**: Automatizar deployments
3. **Monitoreo**: Agregar métricas y alertas
4. **Backup**: Configurar respaldos automáticos
5. **Escalabilidad**: Preparar para múltiples instancias

## 📞 Soporte

Para problemas técnicos:
1. Revisar logs: `docker-compose logs -f`
2. Verificar estado: `docker-compose ps`
3. Contactar al equipo de infraestructura de la facultad

---

**Desarrollado por**: Equipo ProyectAR - UTN FRBA
**Versión**: 1.0.0
**Última actualización**: Enero 2025