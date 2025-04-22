import Foundation

struct Question {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let difficulty: QuizDifficulty
    
    static let allQuestions: [Question] = [
        // 简单难度问题
        Question(
            text: "哪个是最大的肉食性恐龙？",
            options: ["霸王龙", "迅猛龙", "棘龙", "异特龙"],
            correctAnswerIndex: 2,
            explanation: "棘龙是已知最大的肉食性恐龙，体长可达15-18米，比霸王龙还要大。",
            difficulty: .easy
        ),
        Question(
            text: "恐龙在什么时候灭绝的？",
            options: ["三叠纪末期", "侏罗纪末期", "白垩纪末期", "新生代初期"],
            correctAnswerIndex: 2,
            explanation: "恐龙在白垩纪末期（约6600万年前）灭绝，可能是由于小行星撞击地球等原因导致。",
            difficulty: .easy
        ),
        
        // 中等难度问题
        Question(
            text: "下列哪种恐龙是草食性的？",
            options: ["迅猛龙", "三角龙", "霸王龙", "棘龙"],
            correctAnswerIndex: 1,
            explanation: "三角龙是典型的草食性恐龙，它们有着强壮的喙部和特殊的牙齿结构来处理植物。",
            difficulty: .medium
        ),
        Question(
            text: "恐龙蛋化石通常呈什么形状？",
            options: ["完全圆形", "椭圆形", "不规则形状", "方形"],
            correctAnswerIndex: 1,
            explanation: "大多数恐龙蛋化石呈椭圆形，这种形状有助于保护胚胎并防止蛋破裂。",
            difficulty: .medium
        ),
        
        // 困难难度问题
        Question(
            text: "鸟类被认为是哪类恐龙的后代？",
            options: ["蜥臀目恐龙", "鸟臀目恐龙", "兽脚亚目恐龙", "蜥脚亚目恐龙"],
            correctAnswerIndex: 2,
            explanation: "现代鸟类被认为是兽脚亚目恐龙的后代，特别是似鸟龙类，它们共享许多解剖学特征。",
            difficulty: .hard
        ),
        Question(
            text: "什么事件导致了白垩纪-古近纪灭绝？",
            options: ["火山喷发", "气候变化", "小行星撞击", "以上都是"],
            correctAnswerIndex: 3,
            explanation: "科学家认为是多个因素共同作用导致了恐龙灭绝，包括小行星撞击、火山喷发和随之而来的气候变化。",
            difficulty: .hard
        )
    ]
} 