import SwiftUI

struct DinosaurDetailView: View {
    let dinosaur: Dinosaur
    @EnvironmentObject private var viewModel: DinosaurViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 恐龙图片
                AsyncImage(url: dinosaur.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    // 基本信息
                    VStack(alignment: .leading, spacing: 8) {
                        Text(dinosaur.scientificName)
                            .font(.title2)
                            .italic()
                            .foregroundColor(.secondary)
                        
                        // 特征标签
                        HStack(spacing: 12) {
                            FeatureTag(text: dinosaur.period.rawValue, color: .blue)
                            FeatureTag(text: dinosaur.diet.rawValue, color: .green)
                            FeatureTag(text: dinosaur.size.rawValue, color: sizeColor)
                        }
                    }
                    
                    Divider()
                    
                    // 详细描述
                    Text(dinosaur.description)
                        .font(.body)
                        .lineSpacing(6)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(dinosaur.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite(dinosaur)
                } label: {
                    Image(systemName: viewModel.isFavorite(dinosaur) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
    
    private var sizeColor: Color {
        switch dinosaur.size {
        case .small:
            return .green
        case .medium:
            return .blue
        case .large:
            return .orange
        case .huge:
            return .red
        }
    }
}

struct FeatureTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        DinosaurDetailView(
            dinosaur: Dinosaur(
                id: UUID(),
                name: "霸王龙",
                scientificName: "Tyrannosaurus Rex",
                period: .cretaceous,
                diet: .carnivorous,
                size: .large,
                description: "霸王龙是白垩纪晚期最大的陆地掠食动物之一。它们有着巨大的头骨、强壮的下颌和锋利的牙齿。尽管它们的前肢相对较小，但强壮的后腿使它们能够快速移动。",
                imageURL: URL(string: "https://example.com/trex.jpg")!,
                length: 12.3
            )
        )
        .environmentObject(DinosaurViewModel())
    }
} 
