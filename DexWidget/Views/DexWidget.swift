
import SwiftUI
import WidgetKit

struct DexWidget: Widget {
    let kind: String = "DexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: PokemonProvider(),
        ) { entry in
            DexWidgetCompilationView(entry: SimpleEntry.placeholder)
        }
        .configurationDisplayName("Pokemon Status")
        .description("Shows an overview of your pokemon status")
        .supportedFamilies([.systemSmall])
    }
}
