'use client';

import { motion } from 'framer-motion'

const features = [
  {
    title: "Remembers conversations",
    subtitle: "So you never have to repeat yourself."
  },
  {
    title: "Syncs across devices",
    subtitle: "Pick up right where you left off."
  },
  {
    title: "Multimodal",
    subtitle: "Because your thoughts aren’t just words."
  }
]

const WhyDifferent = () => {
  return (
    <section className="py-24 px-6 bg-background">
      <motion.div
        className="max-w-4xl mx-auto text-center mb-12"
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, amount: 0.2 }}
        transition={{ duration: 0.6 }}
      >
        <h2 className="text-4xl font-bold text-foreground">This isn’t just an assistant. It’s your memory.</h2>
      </motion.div>

      <div className="max-w-3xl mx-auto space-y-12">
        {features.map((feature, index) => (
          <motion.div
            key={feature.title}
            className="text-center"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, amount: 0.2 }}
            transition={{ duration: 0.6, delay: index * 0.2 }}
          >
            <h3 className="text-2xl font-semibold text-foreground">{feature.title}</h3>
            <p className="text-muted mt-2">{feature.subtitle}</p>
          </motion.div>
        ))}
      </div>
    </section>
  )
}

export default WhyDifferent