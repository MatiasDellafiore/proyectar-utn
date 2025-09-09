'use client'

import { useState, useEffect } from "react"

export default function TestPage() {
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return null
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white flex items-center justify-center">
      <div className="text-center p-8">
        <div className="mb-8">
          <h1 className="text-6xl font-bold text-blue-600 mb-4">
            🎉 Hola Mundo desde ProyectAR
          </h1>
          <p className="text-2xl text-gray-700 mb-4">
            ¡La integración con la infraestructura de la facultad está funcionando!
          </p>
          <p className="text-lg text-gray-600">
            ProyectAR - UTN Facultad Regional Buenos Aires
          </p>
        </div>
        
        <div className="bg-white rounded-lg shadow-lg p-6 max-w-md mx-auto">
          <h2 className="text-xl font-semibold mb-4">Estado del Sistema</h2>
          <div className="space-y-2 text-left">
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

        <div className="mt-8 text-sm text-gray-500">
          <p>Timestamp: {new Date().toLocaleString('es-AR')}</p>
          <p>Entorno: Producción</p>
        </div>
      </div>
    </div>
  )
}
