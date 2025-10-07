import SwiftUI

struct WelcomeStep: View, TutorialStepView {
    var step: TutorialStep = .welcome
    func nextValidation() -> Bool { true }
    func skipValidation() -> Bool { true }
    var erased: AnyView { AnyView(self) }

    @State private var animate: Bool = false
    @State private var wavePhase: Double = 0

    let timer = Timer.publish(every: 0.024, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 0) {
                ForEach(Array("Mirage").indices, id: \.self) { i in
                    Text(String(Array("Mirage")[i]))
                        .font(.system(size: 48, weight: .heavy, design: .default))
                        .foregroundColor(.white)
                        .offset(y: sin(wavePhase + Double(i)) * 2)
                }
            }
            .onReceive(timer) { _ in
                wavePhase += 0.1 // increment phase over time
            }

            Text("All models, all integrations, all yours.")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .scaleEffect(animate ? 1 : 0.95)
                .opacity(animate ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: animate)

            Text("Let’s take a quick tour to get you started!")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Text("PREVIEW VERSION - 0.1")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
        }
        .padding(24)
        .frame(maxWidth: 400)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 20)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
  let tutorial = TutorialManager()
  
  tutorial.resetTutorials()
  
  let settings = SettingsManager()
  let chatManager = ChatManager(settings: settings)

  return ContentView()
    .environmentObject(tutorial)
    .environmentObject(chatManager)
    .environmentObject(settings)
    .frame(width: 600, height: 400)
    .padding()

}
