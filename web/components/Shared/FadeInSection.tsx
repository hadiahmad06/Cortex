import { ReactNode } from 'react'
import { motion } from 'framer-motion'

interface FadeInSectionProps {
  children: ReactNode
  className?: string
  yOffset?: number // allows customizing the vertical offset
  duration?: number // animation duration in seconds
}

const FadeInSection = ({
  children,
  className = '',
  yOffset = 30,
  duration = 0.6,
}: FadeInSectionProps) => (
  <motion.div
    className={className}
    initial={{ opacity: 0, y: yOffset }}
    whileInView={{ opacity: 1, y: 0 }}
    transition={{ duration, ease: 'easeOut' }}
    viewport={{ once: true, amount: 0.2 }}
  >
    {children}
  </motion.div>
)

export default FadeInSection