import Foundation

struct Score: Codable, Comparable {
    let points: Int

    static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.points < rhs.points
    }
}

class ScoreManager: ObservableObject {
    
    static var shared = ScoreManager()
    
    @Published var topScores: [Score] = []

    let topScoresKey = "topScoresKey"

    init() {
        loadScores()
    }

    func addScore(points: Int) {
        // Проверка на нулевые значения
        guard points > 0 else { return }

        let newScore = Score(points: points)

        // Проверка на дублирующие результаты
        guard !topScores.contains(where: { $0.points == newScore.points }) else { return }

        topScores.append(newScore)
        topScores.sort(by: >)
        
        if topScores.count > 4 {
            topScores.removeLast()
        }

        saveScores()
    }

    func saveScores() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(topScores) {
            UserDefaults.standard.set(encoded, forKey: topScoresKey)
        }
    }

    func loadScores() {
        if let savedScores = UserDefaults.standard.object(forKey: topScoresKey) as? Data {
            let decoder = JSONDecoder()
            if let decodedScores = try? decoder.decode([Score].self, from: savedScores) {
                topScores = decodedScores
            }
        }
    }
}
