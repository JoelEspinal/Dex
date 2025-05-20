
import SwiftUI
import WidgetKit

struct DexWidget: Widget {
    let kind: String = "DexWidget"

    var body: some WidgetConfiguration {
            StaticConfiguration(
                kind: "com.joelespinal.pokemon-dex-widget",
                provider: PokemonProvider(),
            ) { entry in
                DexWidgetCompilationView(entry: SimpleEntry.placeholder)
            }
            .configurationDisplayName("Game Status")
            .description("Shows an overview of your game status")
            .supportedFamilies([.systemSmall])
    }
}
