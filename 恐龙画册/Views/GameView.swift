import SwiftUI

struct GameView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("恐龙拼图")
                .font(.title)
                .bold()
            
            Text("选择难度开始游戏")
                .font(.headline)
                .foregroundColor(.secondary)
            
            NavigationLink {
                PuzzleDifficultyView()
            } label: {
                Text("开始游戏")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .navigationTitle("游戏")
    }
}

#Preview {
    NavigationView {
        GameView()
    }
} 