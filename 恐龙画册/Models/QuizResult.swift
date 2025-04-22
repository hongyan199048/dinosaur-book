import Foundation

struct QuizResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let score: Int
    let totalQuestions: Int
    let difficulty: QuizDifficulty
    
    var percentage: Double {
        Double(score) / Double(totalQuestions)
    }
    
    init(score: Int, totalQuestions: Int, difficulty: QuizDifficulty) {
        self.id = UUID()
        self.date = Date()
        self.score = score
        self.totalQuestions = totalQuestions
        self.difficulty = difficulty
    }
} 