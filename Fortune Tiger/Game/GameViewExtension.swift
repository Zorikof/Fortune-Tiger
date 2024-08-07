import SpriteKit

extension GameScene {
    //MARK: - Objects
    func mainViewSettings() {
        // Получаем индекс выбранного кота из UserDefaults
        let selectedCatIndex = UserDefaults.standard.integer(forKey: "SelectedCatImageIndex")
        let catImageName = "CatV\(selectedCatIndex + 1)"
        
        // Настраиваем catNode с выбранным изображением кота
        catNode = SKSpriteNode(imageNamed: catImageName)
        catNode.size = CGSize(width: 120, height: 140)
        catNode.position = CGPoint(x: size.width / 2, y: 120)
        let smallerBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        catNode.physicsBody = smallerBody
        catNode.physicsBody?.isDynamic = false
        catNode.physicsBody?.categoryBitMask = catCategory
        catNode.physicsBody?.contactTestBitMask = lanternCategory
        addChild(catNode)
        
        // Добавляем задний фон
        let backgroundNode = SKSpriteNode(imageNamed: "GameBackground")
        backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundNode.size = size
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        // Настройка физики мира
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // Запуск таймера для добавления фонариков
        let addLanternAction = SKAction.run { self.addLantern() }
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequenceAction = SKAction.sequence([addLanternAction, waitAction])
        run(SKAction.repeatForever(sequenceAction))
        
        // Добавляем кнопку "Назад в меню"
        let backButton = SKSpriteNode(imageNamed: "BackToMenuButton")
        backButton.size = CGSize(width: 70, height: 70)
        backButton.position = CGPoint(x: 70, y: size.height - 100)
        backButton.name = "BackButton"
        backButton.zPosition = 1
        addChild(backButton)
        
        // Добавляем кнопку "Настройки"
        let settingsButton = SKSpriteNode(imageNamed: "SettingsButton")
        settingsButton.size = CGSize(width: 70, height: 70)
        settingsButton.position = CGPoint(x: size.width - 70, y: size.height - 100)
        settingsButton.name = "SettingsButton"
        settingsButton.zPosition = 1
        addChild(settingsButton)
        
        // Добавляем метку счёта
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor(red: 255/255, green: 191/255, blue: 128/255, alpha: 1.0)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 180)
        scoreLabel.zPosition = 2
        scoreLabel.text = "\(score)"
        addChild(scoreLabel)
        
        // Устанавливаем состояние музыки из UserDefaults
        volume = UserDefaults.standard.bool(forKey: "isMusicOn")
    }
    
    //MARK: - Functions
    func addLantern() {
        let lanternNode = SKSpriteNode(imageNamed: "Lantern")
        lanternNode.size = CGSize(width: 100, height: 100)
        lanternNode.position = CGPoint(x: CGFloat.random(in: 25...(size.width - 25)), y: size.height + 50)
        lanternNode.physicsBody = SKPhysicsBody(rectangleOf: lanternNode.size)
        lanternNode.physicsBody?.isDynamic = true
        lanternNode.physicsBody?.categoryBitMask = lanternCategory
        lanternNode.physicsBody?.contactTestBitMask = catCategory
        lanternNode.physicsBody?.collisionBitMask = 0
        addChild(lanternNode)
        
        let moveAction = SKAction.moveTo(y: -50, duration: 5.0)
        let removeAction = SKAction.run { [weak self] in
            if lanternNode.position.y < 0 {
                self?.gameOver()
            }
            lanternNode.removeFromParent()
        }
        lanternNode.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func incrementScore() {
        score += 20
        scoreLabel.text = "\(score)"
    }
    
    func gameOver() {
        self.isPaused = true
        pause = true
        self.view?.isUserInteractionEnabled = false
        
        // Обновляем значение денег в UserDefaults
        let moneyIncrement = score
        let currentMoney = UserDefaults.standard.integer(forKey: "Money")
        let newMoney = currentMoney + moneyIncrement
        UserDefaults.standard.set(newMoney, forKey: "Money")
        
        ScoreManager.shared.addScore(points: score)
        showGameOverOverlay()
    }
    
    func updateVolumeButtons() {
        volumeOnButton.texture = SKTexture(imageNamed: volume ? "MusicOnDark" : "MusicOnLight")
        volumeOffButton.texture = SKTexture(imageNamed: volume ? "MusicOffLight" : "MusicOffDark")
    }
    
    func hideSettingsOverlay() {
        // Удаляем элементы наложения
        childNode(withName: "Overlay")?.removeFromParent()
        childNode(withName: "ResumeButton")?.removeFromParent()
        childNode(withName: "ExitButton")?.removeFromParent()
        volumeOnButton?.removeFromParent()
        volumeOffButton?.removeFromParent()
    }
    
    func showSettingsOverlay() {
        // Затемняем и размываем сцену
        let overlay = SKSpriteNode(color: .black, size: size)
        overlay.alpha = 0.8
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 2
        overlay.name = "Overlay"
        addChild(overlay)
        
        // Добавляем кнопки настроек
        let resumeButton = SKSpriteNode(imageNamed: "ResumeButton")
        resumeButton.size = CGSize(width: 150, height: 150)
        resumeButton.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        resumeButton.zPosition = 3
        resumeButton.name = "ResumeButton"
        addChild(resumeButton)
        
        volumeOnButton = SKSpriteNode(imageNamed: volume ? "MusicOnLight" : "MusicOnDark")
        volumeOnButton.size = CGSize(width: 70, height: 70)
        volumeOnButton.position = CGPoint(x: size.width / 2 - 40, y: size.height / 2 - 50)
        volumeOnButton.zPosition = 3
        volumeOnButton.name = "VolumeOnButton"
        addChild(volumeOnButton)
        
        volumeOffButton = SKSpriteNode(imageNamed: volume ? "MusicOffDark" : "MusicOffLight")
        volumeOffButton.size = CGSize(width: 70, height: 70)
        volumeOffButton.position = CGPoint(x: size.width / 2 + 40, y: size.height / 2 - 50)
        volumeOffButton.zPosition = 3
        volumeOffButton.name = "VolumeOffButton"
        addChild(volumeOffButton)
        
        let exitButton = SKSpriteNode(imageNamed: "ExitButton")
        exitButton.size = CGSize(width: 160, height: 80)
        exitButton.position = CGPoint(x: size.width / 2, y: 100)
        exitButton.zPosition = 3
        exitButton.name = "ExitButton"
        addChild(exitButton)
        
        updateVolumeButtons()
    }
    
    func showGameOverOverlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view?.isUserInteractionEnabled = true
        }
        // Затемняем и размываем сцену
        let overlay = SKSpriteNode(color: .black, size: size)
        overlay.alpha = 0.8
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 4
        overlay.name = "GameOverOverlay"
        addChild(overlay)
        let victoryLabel = SKSpriteNode(imageNamed: "VictoryLabel")
        victoryLabel.size = CGSize(width: size.width / 1.5, height: size.height / 4)
        victoryLabel.position = CGPoint(x: size.width / 2 + 50, y: size.height - victoryLabel.size.height / 2)
        victoryLabel.zPosition = 4
        victoryLabel.name = "VictoryLabel"
        addChild(victoryLabel)
        
        let leaves = SKSpriteNode(imageNamed: "Leaves")
        leaves.size = CGSize(width: size.width * 0.9, height: size.height * 0.7)
        leaves.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        leaves.zPosition = 4
        leaves.name = "Leaves"
        addChild(leaves)
        let scoresLabel = SKSpriteNode(imageNamed: "ScoresLabel")
        scoresLabel.size = CGSize(width: size.width, height: size.height / 3)
        scoresLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 80)
        scoresLabel.zPosition = 4
        scoresLabel.name = "ScoresLabel"
        addChild(scoresLabel)
        
        let textLabel = SKLabelNode(text: "\(score)")
        textLabel.fontName = "Chalkduster"
        textLabel.fontSize = 80
        textLabel.fontColor = UIColor(red: 255/255, green: 191/255, blue: 128/255, alpha: 1.0)
        textLabel.position = CGPoint(x: 0, y: -scoresLabel.size.height / 6)
        textLabel.zPosition = 5
        textLabel.name = "TextLabel"
        scoresLabel.addChild(textLabel)
        
        let againButton = SKSpriteNode(imageNamed: "AgainButton")
        againButton.size = CGSize(width: size.width / 2, height: size.height / 3)
        againButton.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        againButton.zPosition = 4
        againButton.name = "AgainButton"
        addChild(againButton)
        
        let exitButton = SKSpriteNode(imageNamed: "BackToMenuButton")
        exitButton.size = CGSize(width: 70, height: 70)
        exitButton.position = CGPoint(x: 70, y: size.height - 70)
        exitButton.zPosition = 4
        exitButton.name = "ExitButton"
        addChild(exitButton)
    }
}
