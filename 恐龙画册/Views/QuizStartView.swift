import SwiftUI

struct QuizStartView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 25) {
            Text("恐龙知识问答")
                .font(.largeTitle)
                .bold()
            
            Text("选择难度等级")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ForEach(QuizDifficulty.allCases, id: \.self) { difficulty in
                    NavigationLink(destination: QuizView(difficulty: difficulty)) {
                        DifficultyButton(difficulty: difficulty)
                    }
                }
            }
            .padding(.vertical)
            
            Button("返回") {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.blue)
            .padding(.top)
        }
        .padding()
    }
}

struct DifficultyButton: View {
    let difficulty: QuizDifficulty
    
    var title: String {
        difficulty.rawValue
    }
    
    var subtitle: String {
        switch difficulty {
        case .easy:
            return "适合初学者"
        case .medium:
            return "需要一些恐龙知识"
        case .hard:
            return "真正的恐龙专家"
        }
    }
    
    var color: Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(color)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

struct QuizStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuizStartView()
        }
    }
} 