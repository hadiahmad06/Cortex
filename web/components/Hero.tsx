'use client';

import { motion, useScroll, useTransform } from 'framer-motion'

const Hero = () => {
  const { scrollYProgress } = useScroll()
  const isMobile = typeof window !== 'undefined' && window.innerWidth < 768;

  const leftCircleX = useTransform(scrollYProgress, [0, 0.8], [0, isMobile ? -100 : -300]);
  const rightCircleX = useTransform(scrollYProgress, [0, 0.8], [0, isMobile ? 100 : 300]);
  const leftCircleX2 = useTransform(scrollYProgress, [0, 0.8], [isMobile ? -50 : -150, isMobile ? -150 : -300]);
  const rightCircleX2 = useTransform(scrollYProgress, [0, 0.8], [isMobile ? 50 : 150, isMobile ? 150 : 300]);

  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-6 bg-background">
      {/* Left accent circle */}
      <motion.div
        style={{ x: leftCircleX }}
        className={`absolute left-0 top-1/3 sm:top-1/2 -translate-y-1/2 -translate-x-1/2 rounded-full bg-primary opacity-40 pointer-events-none w-72 h-72 md:w-192 md:h-192 filter blur-xl`}
      />
      {/* Right accent circle */}
      <motion.div
        style={{ x: rightCircleX }}
        className={`absolute right-0 bottom-1/3 sm:top-1/2 -translate-y-1/2 translate-x-1/2 rounded-full bg-primary opacity-40 pointer-events-none w-72 h-72 md:w-192 md:h-192 filter blur-xl`}
      />
      {/* Additional left smaller circle */}
      <motion.div
        style={{ x: leftCircleX2 }}
        className={`absolute left-0 top-1/3 sm:top-1/2 -translate-y-1/2 -translate-x-1/2 rounded-full bg-primary opacity-30 pointer-events-none w-72 h-72 md:w-192 md:h-192 filter blur-md`}
      />
      {/* Additional right smaller circle */}
      <motion.div
        style={{ x: rightCircleX2 }}
        className={`absolute right-0 bottom-1/3 sm:top-1/2 -translate-y-1/2 translate-x-1/2 rounded-full bg-primary opacity-30 pointer-events-none w-72 h-72 md:w-192 md:h-192 filter blur-md`}
      />

      {/* Main content */}
     <div className="text-center max-w-3xl mx-auto">
        <motion.h1 className="text-2xl md:text-7xl font-serif font-bold tracking-tight leading-none text-foreground mb-6">
          Mirage
        </motion.h1>
        <motion.h1 
          className="text-xl md:text-4xl font-bold tracking-tight leading-none text-accent"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
        >
          The AI platform that puts you in control
        </motion.h1>

        <motion.p
          className="mt-6 text-lg md:text-xl text-foreground/70 max-w-xl mx-auto"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.2 }}
        >
          Usage-based, choose any model, synced everywhere
        </motion.p>

        <motion.button
          type="button"
          className="mt-8 inline-block px-8 py-4 text-lg md:text-xl font-bold text-white bg-accent rounded-full shadow-lg hover:bg-accent transition-transform transition-colors duration-200 ease-in-out hover:scale-105"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.4 }}
        >
          Join the waitlist
        </motion.button>
      </div>
    </section>
  )
}

export default Hero