#!/bin/bash

# Script de verificación para ProyectAR
# Uso: ./verify.sh

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🔍 Verificando estado de ProyectAR..."

# Verificar conexión SSH
print_status "Verificando conexión SSH..."
if ssh -o ConnectTimeout=10 proyecto1@vps1.disilab.cpci.org.ar "echo 'Conexión SSH exitosa'" > /dev/null 2>&1; then
    print_success "Conexión SSH establecida"
else
    print_error "No se pudo conectar al servidor"
    exit 1
fi

# Verificar estado de contenedores
print_status "Verificando estado de contenedores..."
ssh proyecto1@vps1.disilab.cpci.org.ar << 'EOF'
    cd ~/proyectar
    
    echo "📊 Estado de contenedores:"
    docker-compose ps
    
    echo ""
    echo "🔍 Verificando salud de contenedores..."
    
    # Verificar que los contenedores estén saludables o en ejecución
    if docker-compose ps | grep -E -q "running \\(healthy\\)|Up"; then
        echo "✅ Contenedores saludables/en ejecución"
    else
        echo "❌ Algunos contenedores no están corriendo/healthy"
        exit 1
    fi
    
    # Verificar logs recientes
    echo ""
    echo "📝 Logs recientes (últimas 10 líneas):"
    docker-compose logs --tail=10
EOF

# Verificar resolución del dominio
print_status "Verificando resolución del dominio..."
if ping -c 1 proyectar.labo.disilab.cpci.org.ar > /dev/null 2>&1; then
    print_success "Dominio resuelve correctamente"
else
    print_warning "El dominio no resuelve. Esto puede ser normal si aún no está configurado."
fi

# Verificar conectividad HTTP
print_status "Verificando conectividad HTTP..."
if curl -s -o /dev/null -w "%{http_code}" https://proyectar.labo.disilab.cpci.org.ar | grep -q "200"; then
    print_success "Aplicación responde correctamente"
else
    print_warning "La aplicación no responde o no está disponible aún"
fi

# Verificar logs de Traefik
print_status "Verificando logs de Traefik..."
ssh proyecto1@vps1.disilab.cpci.org.ar << 'EOF'
    cd /home/ahk/traefik
    
    echo "📝 Logs recientes de Traefik:"
    docker-compose logs --tail=5 traefik
EOF

echo ""
print_success "Verificación completada!"
echo ""
echo "🌐 Tu aplicación debería estar disponible en:"
echo "   https://proyectar.labo.disilab.cpci.org.ar"
echo ""
echo "🔧 Comandos útiles:"
echo "   - Ver logs: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose logs -f'"
echo "   - Estado: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose ps'"
echo "   - Reiniciar: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose restart'"
