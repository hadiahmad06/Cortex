'use client';

import { motion } from 'framer-motion'
import Mockup from './Shared/Mockup'

export interface DeviceImage {
  device: 'phone' | 'web' | 'mac'
  src: string
}

interface DeviceShowcaseProps {
  images: DeviceImage[]
  caption?: string
}

const DeviceShowcase = ({ images, caption }: DeviceShowcaseProps) => {
  return (
    <section className="py-24 px-6 bg-background">
      <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-center gap-8">
        {images.map((img, index) => (
          <motion.div
            key={img.device}
            className="flex-1"
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.2 }}
            transition={{ duration: 0.6, delay: index * 0.2 }}
          >
            <Mockup device={img.device} src={img.src} />
          </motion.div>
        ))}
      </div>

      {caption && (
        <motion.p
          className="text-center text-muted mt-8"
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
        >
          {caption}
        </motion.p>
      )}
    </section>
  )
}

export default DeviceShowcase