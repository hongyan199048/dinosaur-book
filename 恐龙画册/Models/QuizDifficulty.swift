import Foundation
import SwiftUI

enum QuizDifficulty: String, CaseIterable, Codable {
    case easy = "简单"
    case medium = "中等"
    case hard = "困难"
    
    var timeLimit: TimeInterval {
        switch self {
        case .easy:
            return 30
        case .medium:
            return 20
        case .hard:
            return 15
        }
    }
    
    var questionsCount: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 8
        case .hard:
            return 10
        }
    }
    
    var color: Color {
        switch self {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
} 