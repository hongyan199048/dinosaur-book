import Foundation

enum DinosaurPeriod: String, CaseIterable, Codable {
    case triassic = "三叠纪"
    case jurassic = "侏罗纪"
    case cretaceous = "白垩纪"
}

enum DinosaurDiet: String, CaseIterable, Codable {
    case carnivorous = "肉食性"
    case herbivorous = "草食性"
    case omnivorous = "杂食性"
}

enum DinosaurSize: String, CaseIterable, Codable {
    case small = "小型"
    case medium = "中型"
    case large = "大型"
    case huge = "巨型"
}

// 恐龙数据模型
struct Dinosaur: Identifiable, Codable {
    let id: UUID
    let name: String
    let scientificName: String
    let period: DinosaurPeriod
    let diet: DinosaurDiet
    let size: DinosaurSize
    let description: String
    let imageURL: URL
    let length: Double
    var isFavorite: Bool = false
    
    static let allDinosaurs: [Dinosaur] = [
        Dinosaur(
            id: UUID(),
            name: "霸王龙",
            scientificName: "Tyrannosaurus Rex",
            period: .cretaceous,
            diet: .carnivorous,
            size: .huge,
            description: "霸王龙是白垩纪晚期最大的陆地掠食动物之一。它们有着巨大的头骨、强壮的下颌和锋利的牙齿。尽管它们的前肢相对较小，但强壮的后腿使它们能够快速移动。",
            imageURL: URL(string: "https://example.com/trex.jpg")!,
            length: 12.3
        ),
        Dinosaur(
            id: UUID(),
            name: "三角龙",
            scientificName: "Triceratops",
            period: .cretaceous,
            diet: .herbivorous,
            size: .large,
            description: "三角龙是一种大型草食性恐龙，以其独特的三角形头骨和颈部护盾而闻名。它们生活在白垩纪晚期，是当时最常见的恐龙之一。",
            imageURL: URL(string: "https://example.com/triceratops.jpg")!,
            length: 9.0
        ),
        Dinosaur(
            id: UUID(),
            name: "迅猛龙",
            scientificName: "Velociraptor",
            period: .cretaceous,
            diet: .carnivorous,
            size: .small,
            description: "迅猛龙是一种敏捷的小型食肉恐龙，以其智慧和速度著称。它们有着锋利的爪子和强大的后腿，是群居性掠食者。",
            imageURL: URL(string: "https://example.com/velociraptor.jpg")!,
            length: 2.0
        ),
        Dinosaur(
            id: UUID(),
            name: "梁龙",
            scientificName: "Diplodocus",
            period: .jurassic,
            diet: .herbivorous,
            size: .huge,
            description: "梁龙是一种巨大的蜥脚类恐龙，以其极长的脖子和尾巴而闻名。它们是侏罗纪时期最大的陆地动物之一。",
            imageURL: URL(string: "https://example.com/diplodocus.jpg")!,
            length: 27.0
        ),
        Dinosaur(
            id: UUID(),
            name: "棘龙",
            scientificName: "Spinosaurus",
            period: .cretaceous,
            diet: .carnivorous,
            size: .huge,
            description: "棘龙是已知最大的食肉恐龙，以其背部的巨大帆状结构而闻名。它们主要在水域附近活动，以鱼类为食。",
            imageURL: URL(string: "https://example.com/spinosaurus.jpg")!,
            length: 15.0
        )
    ]
} 