import SwiftUI

enum PuzzleDifficulty: String, CaseIterable {
    case easy = "简单"
    case medium = "中等"
    case hard = "困难"
    
    var gridSize: Int {
        switch self {
        case .easy: return 3 // 3x3
        case .medium: return 4 // 4x4
        case .hard: return 5 // 5x5
        }
    }
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
    
    var description: String {
        switch self {
        case .easy: return "3 x 3 块拼图"
        case .medium: return "4 x 4 块拼图"
        case .hard: return "5 x 5 块拼图"
        }
    }
}

struct PuzzleDifficultyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(PuzzleDifficulty.allCases, id: \.self) { difficulty in
                NavigationLink {
                    PuzzleImagePicker(difficulty: difficulty)
                } label: {
                    HStack {
                        Image(systemName: "puzzle.piece.fill")
                            .foregroundColor(difficulty.color)
                        
                        VStack(alignment: .leading) {
                            Text(difficulty.rawValue)
                                .font(.headline)
                            Text(difficulty.description)
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
    }
}

#Preview {
    NavigationView {
        PuzzleDifficultyView()
    }
} 