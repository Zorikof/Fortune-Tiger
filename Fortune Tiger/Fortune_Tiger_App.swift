import SwiftUI
import AVKit

@main
struct Fortune_TigerApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "isMusicOn") {
                        SoundManager.shared.playSound()
                    }
                }
        }
    }
}
