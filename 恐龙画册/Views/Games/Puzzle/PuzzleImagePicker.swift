import SwiftUI

struct PuzzleImage: Identifiable {
    let id = UUID()
    let name: String
    let displayName: String
    let category: PuzzleImageCategory
    var image: UIImage? {
        UIImage(named: name)
    }
}

enum PuzzleImageCategory: String, CaseIterable {
    case dinosaurs = "恐龙"
    case landscapes = "风景"
    case animals = "动物"
    
    var systemImage: String {
        switch self {
        case .dinosaurs: return "fossil.shell.fill"
        case .landscapes: return "mountain.2.fill"
        case .animals: return "pawprint.fill"
        }
    }
    
    var folderName: String {
        switch self {
        case .dinosaurs: return "Dinosaurs"
        case .landscapes: return "Landscapes"
        case .animals: return "Animals"
        }
    }
}

struct PuzzleImagePicker: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: PuzzleImageCategory = .dinosaurs
    let difficulty: PuzzleDifficulty
    
    // 图片数据
    let images: [PuzzleImage] = [
        // 恐龙类别
        PuzzleImage(name: "tyrannosaurus", displayName: "霸王龙", category: .dinosaurs),
        PuzzleImage(name: "triceratops", displayName: "三角龙", category: .dinosaurs),
        PuzzleImage(name: "spinosaurus", displayName: "棘龙", category: .dinosaurs),
        
        // 风景类别
        PuzzleImage(name: "mountain", displayName: "山脉", category: .landscapes),
        PuzzleImage(name: "forest", displayName: "森林", category: .landscapes),
        PuzzleImage(name: "beach", displayName: "海滩", category: .landscapes),
        
        // 动物类别
        PuzzleImage(name: "lion", displayName: "狮子", category: .animals),
        PuzzleImage(name: "elephant", displayName: "大象", category: .animals),
        PuzzleImage(name: "tiger", displayName: "老虎", category: .animals)
    ]
    
    var filteredImages: [PuzzleImage] {
        images.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 类别选择器
            HStack(spacing: 16) {
                ForEach(PuzzleImageCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: category == selectedCategory,
                        action: { selectedCategory = category }
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            
            // 图片网格
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(filteredImages) { puzzleImage in
                        if let image = puzzleImage.image {
                            ImageCard(image: image, title: puzzleImage.displayName, cardHeight: 320) {
                                NavigationLink {
                                    PuzzleGameView(difficulty: difficulty, image: image)
                                } label: {
                                    Text("开始游戏")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.accentColor)
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("选择图片")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategoryButton: View {
    let category: PuzzleImageCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.systemImage)
                    .font(.title2)
                Text(category.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 80)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct ImageCard: View {
    let image: UIImage
    let title: String
    let cardHeight: CGFloat
    let actionView: AnyView
    
    init(image: UIImage, title: String, cardHeight: CGFloat = 320, @ViewBuilder action: () -> some View) {
        self.image = image
        self.title = title
        self.cardHeight = cardHeight
        self.actionView = AnyView(action())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: cardHeight)
                .frame(maxWidth: .infinity)
                .clipped()
            
            Text(title)
                .font(.headline)
                .padding(.vertical, 8)
            
            actionView
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    NavigationView {
        PuzzleImagePicker(difficulty: .easy)
    }
} 