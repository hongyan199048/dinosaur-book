import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = DinosaurViewModel()
    @State private var showingQuiz = false
    
    var body: some View {
        TabView {
            NavigationView {
                DinosaurListView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("图鉴", systemImage: "book.fill")
            }
            
            NavigationView {
                FavoritesView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("收藏", systemImage: "star.fill")
            }
            
            NavigationView {
                QuizEntryView(showingQuiz: $showingQuiz)
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("问答", systemImage: "questionmark.circle.fill")
            }
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $showingQuiz) {
            QuizDifficultyView()
        }
    }
}

struct QuizEntryView: View {
    @Binding var showingQuiz: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("恐龙知识问答")
                .font(.title)
                .bold()
            
            Text("测试你的恐龙知识！\n选择难度开始答题")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button {
                showingQuiz = true
            } label: {
                Text("开始答题")
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
        .navigationTitle("问答")
    }
}

struct FavoritesView: View {
    @EnvironmentObject private var viewModel: DinosaurViewModel
    
    var body: some View {
        Group {
            if viewModel.favoriteDinosaurs.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "star.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("暂无收藏的恐龙")
                        .foregroundColor(.gray)
                }
            } else {
                List(viewModel.favoriteDinosaurs) { dinosaur in
                    NavigationLink {
                        DinosaurDetailView(dinosaur: dinosaur)
                    } label: {
                        DinosaurRow(
                            dinosaur: dinosaur,
                            isFavorite: true
                        )
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.toggleFavorite(dinosaur)
                        } label: {
                            Label("取消收藏", systemImage: "star.slash.fill")
                        }
                    }
                }
            }
        }
        .navigationTitle("我的收藏")
    }
}

#Preview {
    MainView()
} 