import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var hasAnswered = false
    @Published var selectedAnswerIndex: Int?
    @Published var showingScore = false
    @Published var isCorrect = false
    @Published var timeRemaining: TimeInterval
    @Published var isTimerRunning = false
    
    var quiz: Quiz
    private var timer: Timer?
    
    var currentQuestion: Question {
        quiz.questions[currentQuestionIndex]
    }
    
    var progress: Double {
        Double(currentQuestionIndex) / Double(quiz.totalQuestions)
    }
    
    var isQuizComplete: Bool {
        currentQuestionIndex == quiz.questions.count - 1 && hasAnswered
    }
    
    init(difficulty: QuizDifficulty = .easy) {
        self.quiz = Quiz.create(difficulty: difficulty)
        self.timeRemaining = quiz.timeLimit
    }
    
    func startQuiz() {
        startTimer()
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timeExpired()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    private func timeExpired() {
        if !hasAnswered {
            hasAnswered = true
            selectedAnswerIndex = nil
            isCorrect = false
        }
        stopTimer()
    }
    
    func checkAnswer(_ index: Int) {
        guard !hasAnswered else { return }
        
        selectedAnswerIndex = index
        hasAnswered = true
        isCorrect = index == currentQuestion.correctAnswerIndex
        
        if isCorrect {
            score += 1
            SoundManager.shared.playCorrectSound()
        } else {
            SoundManager.shared.playWrongSound()
        }
        
        stopTimer()
    }
    
    func nextQuestion() {
        if currentQuestionIndex < quiz.questions.count - 1 {
            currentQuestionIndex += 1
            hasAnswered = false
            selectedAnswerIndex = nil
            isCorrect = false
            timeRemaining = quiz.timeLimit
            startTimer()
        } else {
            showingScore = true
            SoundManager.shared.playCompleteSound()
        }
    }
    
    func resetQuiz(difficulty: QuizDifficulty = .easy) {
        quiz = Quiz.create(difficulty: difficulty)
        currentQuestionIndex = 0
        score = 0
        hasAnswered = false
        selectedAnswerIndex = nil
        showingScore = false
        isCorrect = false
        timeRemaining = quiz.timeLimit
        stopTimer()
    }
    
    func answerBackgroundColor(for index: Int) -> Color {
        if !hasAnswered {
            return selectedAnswerIndex == index ? .blue.opacity(0.3) : .clear
        }
        
        if index == currentQuestion.correctAnswerIndex {
            return .green.opacity(0.3)
        }
        
        if index == selectedAnswerIndex {
            return .red.opacity(0.3)
        }
        
        return .clear
    }
    
    deinit {
        stopTimer()
    }
} 