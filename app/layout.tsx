import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'ProyectAR - UTN Integration',
  description: 'Sistema de gestión de proyectos finales de la UTN FRBA',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  )
}
