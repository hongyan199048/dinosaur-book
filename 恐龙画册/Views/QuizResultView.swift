import SwiftUI

struct QuizResultView: View {
    @Environment(\.dismiss) private var dismiss
    let score: Int
    let totalQuestions: Int
    
    private var percentage: Double {
        Double(score) / Double(totalQuestions)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // 成绩图标
            Image(systemName: resultImage)
                .font(.system(size: 80))
                .foregroundColor(resultColor)
            
            // 分数显示
            VStack(spacing: 10) {
                Text("得分")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("\(score)/\(totalQuestions)")
                    .font(.system(size: 48, weight: .bold))
                
                Text(String(format: "%.0f%%", percentage * 100))
                    .font(.title)
                    .foregroundColor(.secondary)
            }
            
            // 评价文字
            Text(resultMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            Spacer()
            
            // 完成按钮
            Button {
                dismiss()
            } label: {
                Text("完成")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    private var resultImage: String {
        if percentage >= 0.8 {
            return "star.circle.fill"
        } else if percentage >= 0.6 {
            return "hand.thumbsup.fill"
        } else {
            return "book.fill"
        }
    }
    
    private var resultColor: Color {
        if percentage >= 0.8 {
            return .yellow
        } else if percentage >= 0.6 {
            return .green
        } else {
            return .blue
        }
    }
    
    private var resultMessage: String {
        if percentage >= 0.8 {
            return "太棒了！你是恐龙专家！"
        } else if percentage >= 0.6 {
            return "不错！继续加油！"
        } else {
            return "再接再厉，继续学习！"
        }
    }
}

#Preview {
    NavigationView {
        QuizResultView(score: 4, totalQuestions: 5)
    }
} 