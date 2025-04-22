import Foundation

// 恐龙时期
public enum Period: String, Codable, CaseIterable {
    case triassic = "三叠纪"     // 三叠纪
    case jurassic = "侏罗纪"     // 侏罗纪
    case cretaceous = "白垩纪"   // 白垩纪
}

// 食性类型
public enum DietType: String, Codable, CaseIterable {
    case carnivore = "食肉"    // 食肉
    case herbivore = "食草"    // 食草
    case omnivore = "杂食"     // 杂食
}

// 体型大小
public enum SizeCategory: String, Codable, CaseIterable {
    case tiny = "微小型"         // 微小型
    case small = "小型"         // 小型
    case medium = "中型"        // 中型
    case large = "大型"         // 大型
    case huge = "巨型"          // 巨型
} 