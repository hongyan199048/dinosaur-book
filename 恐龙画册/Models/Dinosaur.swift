import Foundation

struct Dinosaur: Identifiable, Codable {
    let id: UUID
    let name: String
    let scientificName: String
    let period: DinosaurPeriod
    let diet: Diet
    let size: Size
    let description: String
    let imageURL: URL
    let length: Double
    let weight: Double
    let height: Double
    let distribution: String
    let videoURL: URL?
    let mapCoordinates: [Coordinate]?
    let discoveryYear: Int
    let discoverer: String
    let classification: Classification
    let features: [String]
    let relatedSpecies: [String]
    
    struct Coordinate: Identifiable, Codable {
        var id = UUID()
        let latitude: Double
        let longitude: Double
        let locationName: String
    }
    
    enum Classification: String, Codable {
        case theropod = "兽脚类"
        case sauropod = "蜥脚类"
        case ornithopod = "鸟脚类"
        case ceratopsian = "角龙类"
        case ankylosaur = "甲龙类"
        case stegosaur = "剑龙类"
        case pterosaur = "翼龙类"
        case marineReptile = "海洋爬行动物"
    }
}

enum DinosaurPeriod: String, Codable, CaseIterable {
    case triassic = "三叠纪"
    case jurassic = "侏罗纪"
    case cretaceous = "白垩纪"
}

enum Diet: String, Codable, CaseIterable {
    case herbivorous = "草食性"
    case carnivorous = "肉食性"
    case omnivorous = "杂食性"
    case piscivorous = "食鱼性"
}

enum Size: String, Codable, CaseIterable {
    case small = "小型"
    case medium = "中型"
    case large = "大型"
    case huge = "巨型"
}

extension Dinosaur {
    static let allDinosaurs: [Dinosaur] = [
        Dinosaur(
            id: UUID(),
            name: "霸王龙",
            scientificName: "Tyrannosaurus Rex",
            period: .cretaceous,
            diet: .carnivorous,
            size: .large,
            description: "霸王龙是白垩纪晚期最大的陆地掠食动物之一。它们有着巨大的头骨、强壮的下颌和锋利的牙齿。尽管它们的前肢相对较小，但强壮的后腿使它们能够快速移动。霸王龙的咬合力是所有陆地动物中最强的，可以轻易咬碎骨头。",
            imageURL: URL(string: "https://example.com/trex.jpg")!,
            length: 12.3,
            weight: 8.4,
            height: 4.0,
            distribution: "北美洲",
            videoURL: URL(string: "https://example.com/trex-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 45.0, longitude: -100.0, locationName: "蒙大拿州"),
                Coordinate(latitude: 40.0, longitude: -110.0, locationName: "怀俄明州")
            ],
            discoveryYear: 1902,
            discoverer: "巴纳姆·布朗",
            classification: .theropod,
            features: ["巨大的头骨", "强壮的下颌", "锋利的牙齿", "短小的前肢", "强大的咬合力", "敏锐的嗅觉"],
            relatedSpecies: ["特暴龙", "惧龙", "艾伯塔龙", "蛇发女怪龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "棘龙",
            scientificName: "Spinosaurus",
            period: .cretaceous,
            diet: .piscivorous,
            size: .huge,
            description: "棘龙是已知最大的肉食性恐龙，以其背部的巨大帆状结构而闻名。它们主要在水域附近活动，以鱼类为食。棘龙有着鳄鱼般的口鼻部和圆锥形的牙齿，非常适合捕鱼。",
            imageURL: URL(string: "https://example.com/spinosaurus.jpg")!,
            length: 15.0,
            weight: 7.0,
            height: 4.5,
            distribution: "北非",
            videoURL: URL(string: "https://example.com/spinosaurus-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 30.0, longitude: 10.0, locationName: "埃及"),
                Coordinate(latitude: 32.0, longitude: 5.0, locationName: "摩洛哥")
            ],
            discoveryYear: 1912,
            discoverer: "恩斯特·斯特罗默",
            classification: .theropod,
            features: ["帆状背脊", "鳄鱼般的口鼻", "圆锥形牙齿", "半水生生活", "强大的前肢"],
            relatedSpecies: ["重爪龙", "似鳄龙", "激龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "甲龙",
            scientificName: "Ankylosaurus",
            period: .cretaceous,
            diet: .herbivorous,
            size: .large,
            description: "甲龙是最著名的装甲恐龙之一，全身覆盖着厚重的骨板和尖刺。它们有着巨大的尾锤，可以用来防御掠食者。甲龙是白垩纪晚期北美洲最常见的装甲恐龙之一。",
            imageURL: URL(string: "https://example.com/ankylosaurus.jpg")!,
            length: 8.0,
            weight: 6.0,
            height: 2.0,
            distribution: "北美洲",
            videoURL: URL(string: "https://example.com/ankylosaurus-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 45.0, longitude: -100.0, locationName: "蒙大拿州"),
                Coordinate(latitude: 40.0, longitude: -110.0, locationName: "怀俄明州")
            ],
            discoveryYear: 1908,
            discoverer: "巴纳姆·布朗",
            classification: .ankylosaur,
            features: ["全身装甲", "尾锤", "低矮的身体", "强壮的四肢", "骨板保护"],
            relatedSpecies: ["包头龙", "结节龙", "多刺甲龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "沧龙",
            scientificName: "Mosasaurus",
            period: .cretaceous,
            diet: .carnivorous,
            size: .huge,
            description: "沧龙是白垩纪晚期最大的海洋爬行动物之一，以其巨大的体型和强大的捕食能力而闻名。它们有着流线型的身体和强壮的尾巴，可以在水中快速游动。",
            imageURL: URL(string: "https://example.com/mosasaurus.jpg")!,
            length: 18.0,
            weight: 15.0,
            height: 2.0,
            distribution: "全球海洋",
            videoURL: URL(string: "https://example.com/mosasaurus-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 50.0, longitude: 4.0, locationName: "荷兰"),
                Coordinate(latitude: 40.0, longitude: -74.0, locationName: "新泽西州")
            ],
            discoveryYear: 1764,
            discoverer: "彼得·坎珀",
            classification: .marineReptile,
            features: ["流线型身体", "强壮的尾巴", "锋利的牙齿", "双颚关节", "优秀的游泳能力"],
            relatedSpecies: ["海王龙", "倾齿龙", "板踝龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "始祖鸟",
            scientificName: "Archaeopteryx",
            period: .jurassic,
            diet: .carnivorous,
            size: .small,
            description: "始祖鸟是最早被发现的具有羽毛的恐龙之一，被认为是恐龙向鸟类进化的重要证据。它们有着羽毛和翅膀，但同时也保留了恐龙的许多特征。",
            imageURL: URL(string: "https://example.com/archaeopteryx.jpg")!,
            length: 0.5,
            weight: 0.5,
            height: 0.3,
            distribution: "欧洲",
            videoURL: URL(string: "https://example.com/archaeopteryx-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 48.0, longitude: 11.0, locationName: "德国"),
                Coordinate(latitude: 50.0, longitude: 8.0, locationName: "法国")
            ],
            discoveryYear: 1861,
            discoverer: "赫尔曼·冯·迈耶",
            classification: .theropod,
            features: ["羽毛", "翅膀", "牙齿", "长尾巴", "爪状前肢"],
            relatedSpecies: ["近鸟龙", "晓廷龙", "小盗龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "禽龙",
            scientificName: "Iguanodon",
            period: .cretaceous,
            diet: .herbivorous,
            size: .large,
            description: "禽龙是最早被科学描述的恐龙之一，以其独特的拇指尖刺而闻名。它们是白垩纪早期最常见的草食性恐龙之一，主要分布在欧洲和北美洲。",
            imageURL: URL(string: "https://example.com/iguanodon.jpg")!,
            length: 10.0,
            weight: 3.5,
            height: 3.0,
            distribution: "欧洲、北美洲",
            videoURL: URL(string: "https://example.com/iguanodon-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 50.0, longitude: 4.0, locationName: "比利时"),
                Coordinate(latitude: 51.0, longitude: 0.0, locationName: "英国")
            ],
            discoveryYear: 1825,
            discoverer: "吉迪恩·曼特尔",
            classification: .ornithopod,
            features: ["拇指尖刺", "喙状嘴", "强壮的四肢", "长尾巴", "群居生活"],
            relatedSpecies: ["弯龙", "禽龙类", "鸭嘴龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "鱼龙",
            scientificName: "Ichthyosaurus",
            period: .jurassic,
            diet: .piscivorous,
            size: .medium,
            description: "鱼龙是最早被发现的海洋爬行动物之一，以其鱼雷般的身体和优秀的游泳能力而闻名。它们有着流线型的身体和鳍状肢，可以在水中快速游动。",
            imageURL: URL(string: "https://example.com/ichthyosaurus.jpg")!,
            length: 3.0,
            weight: 1.0,
            height: 0.5,
            distribution: "全球海洋",
            videoURL: URL(string: "https://example.com/ichthyosaurus-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 51.0, longitude: -2.0, locationName: "英国"),
                Coordinate(latitude: 50.0, longitude: 8.0, locationName: "德国")
            ],
            discoveryYear: 1821,
            discoverer: "玛丽·安宁",
            classification: .marineReptile,
            features: ["流线型身体", "鳍状肢", "背鳍", "尾鳍", "优秀的游泳能力"],
            relatedSpecies: ["蛇颈龙", "上龙", "薄片龙"]
        ),
        Dinosaur(
            id: UUID(),
            name: "窃蛋龙",
            scientificName: "Oviraptor",
            period: .cretaceous,
            diet: .omnivorous,
            size: .small,
            description: "窃蛋龙是一种小型兽脚类恐龙，以其独特的头冠和喙状嘴而闻名。它们最初被认为是以偷食其他恐龙的蛋为生，但后来的发现表明它们可能是在保护自己的蛋。",
            imageURL: URL(string: "https://example.com/oviraptor.jpg")!,
            length: 2.0,
            weight: 0.5,
            height: 1.0,
            distribution: "亚洲",
            videoURL: URL(string: "https://example.com/oviraptor-video.mp4"),
            mapCoordinates: [
                Coordinate(latitude: 45.0, longitude: 100.0, locationName: "蒙古"),
                Coordinate(latitude: 40.0, longitude: 110.0, locationName: "中国")
            ],
            discoveryYear: 1924,
            discoverer: "亨利·费尔菲尔德·奥斯本",
            classification: .theropod,
            features: ["头冠", "喙状嘴", "无齿", "长尾巴", "羽毛"],
            relatedSpecies: ["尾羽龙", "窃蛋龙类", "伤齿龙"]
        )
    ]
} 