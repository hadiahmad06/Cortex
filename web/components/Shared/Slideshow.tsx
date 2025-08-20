'use client';

import { useState, useEffect, ReactNode } from 'react'
import { motion, AnimatePresence } from 'framer-motion'

interface Slide {
  id: string | number
  content: ReactNode
}

interface SlideshowProps {
  slides: Slide[]
  interval?: number // ms per slide
  className?: string
}

const Slideshow = ({ slides, interval = 5000, className = '' }: SlideshowProps) => {
  const [current, setCurrent] = useState(0)

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrent((prev) => (prev + 1) % slides.length)
    }, interval)
    return () => clearInterval(timer)
  }, [slides.length, interval])

  return (
    <div className={`relative overflow-hidden ${className}`}>
      <AnimatePresence>
        {slides.map((slide, index) =>
          index === current ? (
            <motion.div
              key={slide.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              transition={{ duration: 0.6, ease: 'easeOut' }}
              className="absolute inset-0 w-full h-full"
            >
              {slide.content}
            </motion.div>
          ) : null
        )}
      </AnimatePresence>
    </div>
  )
}

export default Slideshow