import SwiftUI
import WidgetKit

struct UpNextLockScreenWidget: Widget {
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return StaticConfiguration(kind: "Up_Next_Lock_Screen_Widget", provider: UpNextProvider()) { entry in
                UpNextLockScreenWidgetEntryView(entry: entry)
            }
            .configurationDisplayName(L10n.upNext)
            .description(L10n.widgetsUpNextDescription)
            .supportedFamilies([.accessoryCircular])
        }
        else {
            return EmptyWidgetConfiguration()
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct UpNextLockScreenWidgetEntryView: View {
    @State var entry: UpNextProvider.Entry

    var numberOfEpisodeInUpNext: Int {
        entry.upNextEpisodesCount ?? 0
    }

    var widgetURL: String {
        return numberOfEpisodeInUpNext != 0 ? "pktc://upnext" : "pktc://discover"
    }

    var font: Font {
        numberOfEpisodeInUpNext > 99 ? .callout : .title
    }

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()

            VStack {
                HStack(spacing: 2) {
                    Text("\(numberOfEpisodeInUpNext)")
                        .font(font)
                        .lineLimit(1)

                    Image("up-next")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 12)
                }
            }
        }
        .widgetURL(URL(string: widgetURL))
    }
}

@available(iOSApplicationExtension 16.0, *)
struct Previews_UpNextLockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        UpNextLockScreenWidgetEntryView(entry: UpNextEntry(date: Date(), isPlaying: false, upNextEpisodesCount: 18))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}