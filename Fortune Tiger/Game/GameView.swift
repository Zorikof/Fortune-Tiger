import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var catNode: SKSpriteNode!
    let lanternCategory: UInt32 = 0x1 << 0
    let catCategory: UInt32 = 0x1 << 1
    var pause = false
    var volume = false
    var score = 0
    
    var scoreLabel: SKLabelNode!
    var volumeOnButton: SKSpriteNode!
    var volumeOffButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        mainViewSettings()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == lanternCategory && contact.bodyB.categoryBitMask == catCategory {
            contact.bodyA.node?.removeFromParent()
            incrementScore()
        } else if contact.bodyA.categoryBitMask == catCategory && contact.bodyB.categoryBitMask == lanternCategory {
            contact.bodyB.node?.removeFromParent()
            incrementScore()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pause {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            // Ограничиваем движение кота по вертикали
            let maxHeight = size.height * 0.3
            let newY = min(max(location.y, 0), maxHeight)
            
            let action = SKAction.moveTo(x: location.x, duration: 0.1)
            let verticalAction = SKAction.moveTo(y: newY, duration: 0.1)
            
            catNode.run(action)
            catNode.run(verticalAction)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        switch touchedNode.name {
        case "BackButton":
            navigateToMenuView()
        case "SettingsButton":
            pauseGameAndShowSettings()
        case "VolumeOnButton":
            if !volume {
                volume = true
                updateVolumeButtons()
                UserDefaults.standard.set(volume, forKey: "isMusicOn")
                SoundManager.shared.playSound()
                
            }
        case "VolumeOffButton":
            if volume {
                volume = false
                updateVolumeButtons()
                UserDefaults.standard.set(volume, forKey: "isMusicOn")
                SoundManager.shared.stopSound()
                
            }
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if touchedNode.name == "ResumeButton" {
            hideSettingsOverlay()
            self.isPaused = false
            pause = false
        } else if touchedNode.name == "ExitButton" {
            // Переход к MenuView
            navigateToMenuView()
        } else if touchedNode.name == "AgainButton" {
            restartGame()
        }
    }
    
    private func restartGame() {
        if let view = self.view {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 1.0)
            view.presentScene(newScene, transition: transition)
        }
    }
    
    private func navigateToMenuView() {
        if let view = self.view {
            let menuView = MenuView()
            let hostingController = UIHostingController(rootView: menuView)
            view.window?.rootViewController = hostingController
        }
    }
    
    private func pauseGameAndShowSettings() {
        self.isPaused = true
        pause = true
        showSettingsOverlay()
    }
}

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameView()
}
