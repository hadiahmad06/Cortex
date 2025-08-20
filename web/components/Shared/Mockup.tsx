import { motion } from 'framer-motion'

interface MockupProps {
  device: 'phone' | 'web' | 'mac'
  src?: string // optional image src override
  alt?: string
  className?: string
  parallax?: boolean
  offset?: number // vertical parallax offset
}

const Mockup = ({
  device,
  src,
  alt,
  className = '',
  parallax = false,
  offset = 0,
}: MockupProps) => {
  // Default placeholder images
  const defaultSrc = {
    phone: '/mockup-phone.png',
    web: '/mockup-web.png',
    mac: '/mockup-mac.png',
  }[device]

  return (
    <motion.img
      src={src || defaultSrc}
      alt={alt || `${device} mockup`}
      className={`rounded-xl shadow-xl ${className}`}
      style={parallax ? { y: offset } : {}}
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6, ease: 'easeOut' }}
      viewport={{ once: true, amount: 0.2 }}
    />
  )
}

export default Mockup