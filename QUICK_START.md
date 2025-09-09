# 🚀 Quick Start - ProyectAR Integration

## Pasos Rápidos para el Primer Deployment

### 1. Preparar el Entorno
```bash
cd /home/matias-dellafiore/Documents/Facu/Proyecto\ Final/Repositorios/proyectar-utn
```

### 2. Ejecutar Deployment
```bash
./deploy.sh
```

### 3. Verificar Deployment
```bash
./verify.sh
```

### 4. Acceder a la Aplicación
Visita: **https://proyectar.labo.disilab.cpci.org.ar**

---

## 🔧 Comandos de Emergencia

### Si algo sale mal:
```bash
# Detener todo
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose down'

# Ver logs
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose logs -f'

# Reiniciar
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose restart'
```

### Ver logs de Traefik:
```bash
ssh proyecto1@vps1.disilab.cpci.org.ar 'cd /home/ahk/traefik && docker-compose logs -f traefik'
```

---

## 📋 Checklist Pre-Deployment

- [ ] SSH configurado y funcionando
- [ ] Dominio `proyectar.labo.disilab.cpci.org.ar` resuelve
- [ ] Red `web` existe en Traefik
- [ ] Archivos en el directorio correcto

---

## 🎯 Objetivo

Mostrar "Hola Mundo desde ProyectAR" en https://proyectar.labo.disilab.cpci.org.ar

---

**Nota**: Este es un setup de prueba. Para producción, cambiar el dominio a `proyectar.edu.ar` y configurar variables de entorno seguras.
