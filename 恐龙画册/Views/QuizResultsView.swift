import SwiftUI

struct QuizResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var results: [QuizResult] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results.reversed()) { result in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(result.difficulty.rawValue)
                                .font(.headline)
                                .foregroundColor(result.difficulty.color)
                            Spacer()
                            Text(formatDate(result.date))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("得分：\(result.score)/\(result.totalQuestions)")
                            Spacer()
                            Text(String(format: "%.0f%%", result.percentage * 100))
                                .bold()
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("历史成绩")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadResults()
        }
    }
    
    private func loadResults() {
        let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("quiz_results.json")
        
        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) {
            results = decoded
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    QuizResultsView()
} 