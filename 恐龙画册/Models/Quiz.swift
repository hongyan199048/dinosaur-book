import Foundation

struct Quiz {
    let questions: [Question]
    let difficulty: QuizDifficulty
    let timeLimit: TimeInterval
    
    var totalQuestions: Int {
        questions.count
    }
    
    static func create(difficulty: QuizDifficulty, questionCount: Int = 5) -> Quiz {
        let filteredQuestions = Question.allQuestions.filter { $0.difficulty == difficulty }
        let selectedQuestions = Array(filteredQuestions.shuffled().prefix(questionCount))
        
        let timeLimit: TimeInterval
        switch difficulty {
        case .easy:
            timeLimit = 30
        case .medium:
            timeLimit = 20
        case .hard:
            timeLimit = 15
        }
        
        return Quiz(
            questions: selectedQuestions,
            difficulty: difficulty,
            timeLimit: timeLimit
        )
    }
    
    static let example = Quiz(
        questions: Array(Question.allQuestions.prefix(5)),
        difficulty: .easy,
        timeLimit: 30
    )
} 