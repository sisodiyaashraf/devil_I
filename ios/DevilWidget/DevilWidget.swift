import WidgetKit
import SwiftUI

struct DevilEntry: TimelineEntry {
    let date: Date
    let activePact: String
    let soulFrequency: Double
    let rank: String
}

struct DevilWidgetEntryView : View {
    var entry: DevilEntry

    var body: some View {
        ZStack {
            // THE OBSIDIAN GLASS BACKGROUND
            ContainerRelativeShape()
                .fill(Color.black)

            // ACCENT GLOW (Red for Hell, Gold for Heaven)
            RadialGradient(
                colors: [Color.red.opacity(0.15), Color.clear],
                center: .bottomTrailing,
                startRadius: 5,
                endRadius: 150
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("RANK: \(entry.rank)")
                        .font(.custom("SpaceMono-Bold", size: 10))
                        .foregroundColor(.red)
                    Spacer()
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                }

                Spacer()

                Text(entry.activePact.uppercased())
                    .font(.custom("Cinzel-Black", size: 14))
                    .foregroundColor(.white)

                // SOUL FREQUENCY GAUGE
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.1)).frame(height: 4)
                        Capsule()
                            .fill(Color.red)
                            .frame(width: geo.size.width * CGFloat(entry.soulFrequency), height: 4)
                            .shadow(color: .red, radius: 5)
                    }
                }.frame(height: 4)

                Text("SOUL FREQUENCY: \(Int(entry.soulFrequency * 100))%")
                    .font(.custom("SpaceMono-Regular", size: 8))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding()
        }
        // DEEP LINK TO TRIGGER VIDEO SPLASH
        .widgetURL(URL(string: "devil-app://summon_car"))
    }
}