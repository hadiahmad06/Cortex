'use client'

import { motion, useScroll, useTransform } from 'framer-motion'
import { useRef } from 'react'

const PlaceholderImage = () => {
  return (
    <div className="w-64 h-64 bg-gradient-to-br from-indigo-400 to-pink-400 rounded-xl shadow-lg" />
  )
}

const WhyDifferent = () => {
  const ref = useRef(null)
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start end", "center center"], // when section enters/leaves viewport
  })


  // Exponential/quadratic ease-out helper with optional start/end
  const eased = (value: number, start = 0, end = 1) => {
    // clamp and normalize value to 0->1 within start->end
    const t = Math.min(Math.max((value - start) / (end - start), 0), 1)
    return 1 - Math.pow(1 - t, 2) // quadratic ease-out
  }

  const textX1 = useTransform(scrollYProgress, value => -400 + eased(value, 0, 0.6) * 400)
  const textX2 = useTransform(scrollYProgress, value => -400 + eased(value, 0.4, 1) * 400)
  const textOpacity = useTransform(scrollYProgress, value => eased(Math.min(value / 0.3, 1))) // normalized to 0-1

  const imgX = useTransform(scrollYProgress, value => 200 - eased(value) * 200)
  const imgRotateZ = useTransform(scrollYProgress, value => -20 + eased(value) * 50)
  const imgRotateY = useTransform(scrollYProgress, value => -50 + eased(value, 0, 0.5) * 50)
  const imgOpacity = useTransform(scrollYProgress, value => eased(Math.min(value / 0.3, 1)))

  return (
    <section ref={ref} className="py-24 px-6 bg-background">
      <div className="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-2 items-center gap-12">
        {/* Left side: text */}

        <div className="flex flex-col">
          <motion.h2
            className="text-5xl font-bold text-foreground leading-tight"
            style={{ x: textX1, opacity: textOpacity }}
          >
            All Models.
          </motion.h2>

          <motion.h2
            className="text-5xl font-bold text-foreground leading-tight"
            style={{ x: textX2, opacity: textOpacity }}
          >
            All Yours.
          </motion.h2>
        </div>

        {/* Right side: scroll-tied image */}
        <motion.div
          className="flex justify-center"
          style={{
            x: imgX,
            opacity: imgOpacity,
            rotateZ: imgRotateZ,
            rotateY: imgRotateY,
          }}
        >
          <PlaceholderImage />
        </motion.div>
      </div>
    </section>
  )
}

export default WhyDifferent