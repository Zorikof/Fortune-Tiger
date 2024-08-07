import Foundation
import AVKit

class SoundManager {
    static let shared = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Sound", withExtension:"mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // бесконечное повторение
            player?.play()
        } catch {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        player?.stop()
    }
}

