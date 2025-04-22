import SwiftUI

struct QuizDifficultyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(QuizDifficulty.allCases, id: \.self) { difficulty in
                    NavigationLink {
                        QuizView(difficulty: difficulty)
                    } label: {
                        HStack {
                            Image(systemName: difficultyIcon(for: difficulty))
                                .foregroundColor(difficultyColor(for: difficulty))
                            
                            VStack(alignment: .leading) {
                                Text(difficulty.rawValue)
                                    .font(.headline)
                                Text(difficultyDescription(for: difficulty))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("选择难度")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func difficultyIcon(for difficulty: QuizDifficulty) -> String {
        switch difficulty {
        case .easy:
            return "star"
        case .medium:
            return "star.leadinghalf.filled"
        case .hard:
            return "star.fill"
        }
    }
    
    private func difficultyColor(for difficulty: QuizDifficulty) -> Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
    
    private func difficultyDescription(for difficulty: QuizDifficulty) -> String {
        switch difficulty {
        case .easy:
            return "适合初学者，每题30秒"
        case .medium:
            return "需要一定知识，每题20秒"
        case .hard:
            return "考验专业知识，每题15秒"
        }
    }
}

#Preview {
    QuizDifficultyView()
} 