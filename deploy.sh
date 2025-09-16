#!/bin/bash

# Script de deployment para ProyectAR en la infraestructura de la facultad
# Uso: ./deploy.sh

set -e

echo "🚀 Iniciando deployment de ProyectAR..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
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

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    print_error "No se encontró docker-compose.yml. Asegúrate de estar en el directorio correcto."
    exit 1
fi


# Verificar conexión SSH
print_status "Verificando conexión SSH..."
if ! ssh -o ConnectTimeout=10 proyecto1@vps1.disilab.cpci.org.ar "echo 'Conexión SSH exitosa'" > /dev/null 2>&1; then
    print_error "No se pudo conectar al servidor. Verifica tu configuración SSH."
    exit 1
fi
print_success "Conexión SSH establecida"

# Verificar que el dominio resuelve
print_status "Verificando resolución del dominio..."
if ! ping -c 1 proyectar.labo.disilab.cpci.org.ar > /dev/null 2>&1; then
    print_warning "El dominio proyectar.labo.disilab.cpci.org.ar no resuelve. Esto puede ser normal si aún no está configurado."
else
    print_success "Dominio resuelve correctamente"
fi

# Subir archivos al servidor
print_status "Subiendo archivos al servidor..."
scp docker-compose.yml Dockerfile package.json next.config.mjs tailwind.config.ts postcss.config.mjs tsconfig.json env.production .gitignore proyecto1@vps1.disilab.cpci.org.ar:~/proyectar/
scp -r app/ proyecto1@vps1.disilab.cpci.org.ar:~/proyectar/
print_success "Archivos subidos"

# Conectar al servidor y ejecutar deployment
print_status "Conectando al servidor para deployment..."
ssh proyecto1@vps1.disilab.cpci.org.ar << 'EOF'
    cd ~/proyectar
    
    echo "🔄 Deteniendo contenedores existentes..."
    docker-compose down || true
    
    echo "🏗️ Construyendo nueva imagen..."
    docker-compose build --no-cache
    
    echo "🚀 Iniciando servicios..."
    docker-compose up -d
    
    echo "⏳ Esperando que los servicios estén listos..."
    sleep 10
    
    echo "📊 Estado de los contenedores:"
    docker-compose ps
    
    echo "📝 Logs recientes:"
    docker-compose logs --tail=20
EOF

print_success "Deployment completado!"
print_status "Tu aplicación debería estar disponible en: https://proyectar.labo.disilab.cpci.org.ar"

echo ""
echo "🔧 Comandos útiles para debugging:"
echo "  - Ver logs: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose logs -f'"
echo "  - Estado: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose ps'"
echo "  - Reiniciar: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose restart'"
echo "  - Detener: ssh proyecto1@vps1.disilab.cpci.org.ar 'cd ~/proyectar && docker-compose down'"
