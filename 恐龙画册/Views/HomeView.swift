import SwiftUI

// 确保所有视图都在同一个模块中
struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 标题
                    Text("恐龙世界")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // 恐龙图鉴按钮
                    NavigationLink(destination: DinosaurListView()) {
                        HomeButton(
                            title: "恐龙图鉴",
                            subtitle: "探索各种恐龙",
                            systemImage: "book.fill",
                            color: .blue
                        )
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct HomeButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 