import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(difficulty: QuizDifficulty) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(difficulty: difficulty))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 进度条和计时器
            HStack {
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(.linear)
                    .tint(.blue)
                
                Spacer()
                
                Text(String(format: "%.0f", viewModel.timeRemaining))
                    .font(.headline)
                    .foregroundColor(viewModel.timeRemaining < 5 ? .red : .primary)
                    .frame(width: 30)
            }
            .padding(.horizontal)
            
            // 分数显示
            Text("得分: \(viewModel.score)/\(viewModel.quiz.totalQuestions)")
                .font(.headline)
            
            // 问题显示
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.currentQuestion.text)
                    .font(.title3)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                // 选项按钮
                VStack(spacing: 12) {
                    ForEach(viewModel.currentQuestion.options.indices, id: \.self) { index in
                        Button {
                            viewModel.checkAnswer(index)
                        } label: {
                            HStack {
                                Text(viewModel.currentQuestion.options[index])
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if viewModel.hasAnswered {
                                    if index == viewModel.currentQuestion.correctAnswerIndex {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    } else if index == viewModel.selectedAnswerIndex {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(viewModel.answerBackgroundColor(for: index))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }
                        .disabled(viewModel.hasAnswered)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // 解释文本
            if viewModel.hasAnswered {
                Text(viewModel.currentQuestion.explanation)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            // 下一题按钮
            if viewModel.hasAnswered {
                Button {
                    if viewModel.isQuizComplete {
                        viewModel.showingScore = true
                    } else {
                        viewModel.nextQuestion()
                    }
                } label: {
                    Text(viewModel.isQuizComplete ? "查看结果" : "下一题")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("恐龙知识问答")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("退出") {
                    dismiss()
                }
            }
        }
        .onAppear {
            viewModel.startQuiz()
        }
        .sheet(isPresented: $viewModel.showingScore) {
            QuizResultView(score: viewModel.score, totalQuestions: viewModel.quiz.totalQuestions)
        }
    }
}

#Preview {
    NavigationView {
        QuizView(difficulty: .easy)
    }
} 