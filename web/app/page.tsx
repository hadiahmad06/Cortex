import Hero from '../components/Hero'
import ComparisonSection from '../components/ComparisonSection'
import WhyDifferent from '../components/WhyDifferent'
import DeviceShowcase, { DeviceImage } from '../components/DeviceShowcase'
import Footer from '../components/Footer'

// Sample data for comparisons
const comparisonData = [
  {
    id: 1,
    title: "Fitness",
    prompt: "should i switch to an upper lower workout split?",
    otherAI:
      "The benefits of an upper lower split are increased recovery time, balanced workload, and efficient muscle targeting. It allows you to train major muscle groups more frequently than a body-part split.",
    ourAI:
      "I think you should. You’ve mentioned struggling to stick to 5 workouts per week — an upper/lower split lets you train just 4 days and still hit every muscle group. It fits your schedule without sacrificing progress."
  },
  {
    id: 2,
    title: "Nutrition",
    prompt: "should i try intermittent fasting?",
    otherAI:
      "Intermittent fasting can support weight loss and improve insulin sensitivity. Common methods include 16:8 fasting and alternate-day fasting. It may not be suitable for everyone.",
    ourAI:
      "You’ve said skipping breakfast makes you lightheaded, so strict intermittent fasting might not work for you. A better fit could be an earlier dinner or a gentler 12:12 fast — you’ll still get benefits without crashing in the mornings."
  },
  {
    id: 3,
    title: "Time Management",
    prompt: "how can i get more done in the evenings?",
    otherAI:
      "You can increase productivity by setting goals, creating to-do lists, and avoiding distractions like TV and social media.",
    ourAI:
      "You’ve told me you feel drained after work. Instead of cramming in more tasks, you could set aside 30 minutes for dinner and downtime first — then focus on one priority project. You’ll get more done without burning out."
  }
]

// Sample device images (can be placeholders)
const deviceImages: DeviceImage[] = [
  { device: "phone", src: "/mockup-phone.png" },
  { device: "web", src: "/mockup-web.png" },
  { device: "mac", src: "/mockup-mac.png" }
]

export default function LandingPage() {
  return (
    <div className="bg-background text-foreground">
      {/* Hero Section */}
      <Hero />

      {/* Comparison Section */}
      <ComparisonSection examples={comparisonData} />

      {/* Why It’s Different Section */}
      {/* <WhyDifferent /> */}

      {/* Device Showcase Section */}
      {/* <DeviceShowcase images={deviceImages} caption="Work anywhere. Pick up right where you left off." /> */}

      {/* Footer */}
      <Footer />
    </div>
  )
}