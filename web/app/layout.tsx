import type { Metadata } from 'next'
import { GeistSans } from 'geist/font/sans'
import { GeistMono } from 'geist/font/mono'
import './globals.css'

export const metadata: Metadata = {
  title: 'Mirage – AI that doesn\'t forget.',
  description: 'Ask Mirage anything, it remembers your past conversations, so you don\'t have to provide context every time.',
  keywords: ['AI', 'RAG', 'personal AI assistant', 'openrouter', 'usage-based pricing'],
  authors: [{ name: 'Hadi Ahmad', url: 'https://linkedin.com/in/hadiahmad06' }],
  colorScheme: 'light',
  viewport: 'width=device-width, initial-scale=1',
  openGraph: {
    title: 'Mirage – AI that doesn\'t forget.',
    description: 'Ask Mirage anything, it remembers your past conversations, so you don\'t have to provide context every time.',
    url: 'https://mirag.app',
    siteName: 'Mirage',
    type: 'website',
    images: [
      {
        url: 'https://mirag.app/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Mirage - AI that doesn\'t forget.',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Mirage – AI that doesn\'t forget.',
    description: 'Ask Mirage anything, it remembers your past conversations, so you don\'t have to provide context every time.',
    creator: '@hadiahmad06',
    images: ['https://mirag.app/og-image.png'],
  },
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en">
      <head>
        <style>{`
html {
  font-family: ${GeistSans.style.fontFamily};
  --font-sans: ${GeistSans.variable};
  --font-mono: ${GeistMono.variable};
}
        `}</style>
      </head>
      <body>{children}</body>
    </html>
  )
}
