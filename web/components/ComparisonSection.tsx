'use client';

interface ComparisonExample {
  id: number
  title: string
  prompt: string
  otherAI: string
  ourAI: string
}

interface ComparisonSectionProps {
  examples: ComparisonExample[]
}

const OasisIcon = () => (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      className="inline-block w-5 h-5 ml-2 -mt-0.5"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth={2}
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M12 20c4-1 6-3 6-5a6 6 0 10-12 0c0 2 2 4 6 5z" />
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M12 15V9m0 0l2 2m-2-2l-2 2" />
    </svg>
  )

const ComparisonSection = ({ examples }: ComparisonSectionProps) => {
  return (
    <section className="py-24 px-6 bg-background w-full relative">
      <div className="max-w-7xl mx-auto mb-8">
        <div className="bg-lilac-100 text-center font-bold rounded-md py-3 px-4 text-lilac-800">
          Upcoming Feature: Advanced Memory AI Comparison (coming soon!)
        </div>
        <div className="text-center text-sm text-gray-500 mt-2">
          This feature will allow the AI to remember previous interactions, enabling natural, continuous conversations with less repeated context.
        </div>
      </div>
      <div className="max-w-7xl mx-auto grid gap-8">
        {examples.map((example) => (
          <div
            key={example.id}
            className="grid grid-cols-1 md:grid-cols-3 gap-6"
          >
            <div className="bg-gray-300 rounded-xl p-6 text-gray-900 flex flex-col shadow-lg">
              <p className="text-xs font-semibold mb-2 uppercase tracking-wide flex items-center">
                Other AI
              </p>
              <p className="whitespace-pre-wrap text-sm">{example.otherAI}</p>
            </div>
            <div className="bg-gray-100 rounded-xl p-6 text-gray-800 flex flex-col shadow-lg">
              <p className="text-xs font-semibold mb-2 uppercase tracking-wide flex items-center">
                Prompt
              </p>
              <p className="whitespace-pre-wrap text-sm">{example.prompt}</p>
            </div>
            <div className="bg-accent rounded-xl p-6 text-accent-foreground flex flex-col shadow-lg">
              <p className="text-xs font-semibold mb-2 uppercase tracking-wide flex items-center">
                Our AI
              </p>
              <p className="whitespace-pre-wrap text-sm">{example.ourAI}</p>
            </div>
          </div>
        ))}
      </div>
    </section>
  )
}

export default ComparisonSection

// Tailwind custom colors (to be added in tailwind.config.js):
// pastel-pink: #FDE8E8
// pastel-green: #E8F5E9
// lilac-100: #E6E6FA
// lilac-800: #6B46C1