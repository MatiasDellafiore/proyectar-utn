'use client'

import { useState, useEffect } from "react"

export default function HomePage() {
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return null
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      {/* Header */}
      <header className="border-b bg-white/80 backdrop-blur-sm sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <div className="flex items-center space-x-2">
            <h1 className="text-2xl font-bold text-gray-900">ProyectAR</h1>
          </div>
          <nav className="flex items-center space-x-4">
            <a href="/test" className="text-gray-600 hover:text-blue-600">
              Página de Prueba
            </a>
          </nav>
        </div>
      </header>

      {/* Hero Section */}
      <section className="py-20 px-4">
        <div className="container mx-auto text-center">
          <h2 className="text-5xl font-bold text-gray-900 mb-6">
            ProyectAR - Integración UTN
          </h2>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            Sistema de gestión de proyectos finales de la UTN Facultad Regional Buenos Aires.
            Integrado con la infraestructura de la facultad.
          </p>

          <div className="bg-white rounded-lg shadow-lg p-8 max-w-2xl mx-auto">
            <h3 className="text-2xl font-semibold mb-6">Estado del Sistema</h3>
            <div className="grid md:grid-cols-2 gap-4 text-left">
              <div className="flex justify-between">
                <span>Frontend:</span>
                <span className="text-green-600 font-semibold">✅ Activo</span>
              </div>
              <div className="flex justify-between">
                <span>Docker:</span>
                <span className="text-green-600 font-semibold">✅ Funcionando</span>
              </div>
              <div className="flex justify-between">
                <span>Traefik:</span>
                <span className="text-green-600 font-semibold">✅ Conectado</span>
              </div>
              <div className="flex justify-between">
                <span>Dominio:</span>
                <span className="text-blue-600 font-semibold">proyectar.labo.disilab.cpci.org.ar</span>
              </div>
            </div>
          </div>

          <div className="mt-8">
            <a 
              href="/test" 
              className="inline-block bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors"
            >
              Ver Página de Prueba
            </a>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="container mx-auto px-4 text-center">
          <div className="mb-4">
            <h4 className="text-xl font-bold">ProyectAR</h4>
            <p className="text-gray-400">
              UTN Facultad Regional Buenos Aires
            </p>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-gray-400">
            <p>&copy; 2024 ProyectAR - UTN FRBA. Todos los derechos reservados.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
