import Combine
import SwiftUI

class StoriesModel: ObservableObject {
    @Published var progress: Double

    private let dataSource: StoriesDataSource
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    private var interval: TimeInterval = 5.seconds

    var numberOfStories: Int {
        dataSource.numberOfStories
    }

    init(dataSource: StoriesDataSource) {
        self.dataSource = dataSource
        self.progress = 0
        self.publisher = Timer.publish(every: 0.01, on: .main, in: .default)
    }

    func start() {
        cancellable = publisher.autoconnect().sink(receiveValue: {  _ in
            var newProgress = self.progress + (0.01 / self.interval)
            if Int(newProgress) >= self.numberOfStories { newProgress = 0 }
            self.progress = newProgress
        })
    }

    func story(index: Int) -> AnyView {
        dataSource.storyView(for: index)
    }

    func next() {
        progress = Double(Int(progress) + 1)
    }

    func previous() {
        progress = Double(Int(progress) - 1)
    }
}
