import SwiftUI

extension DietType {
    var iconName: String {
        switch self {
        case .carnivore:
            return "flame.fill"
        case .herbivore:
            return "leaf.fill"
        case .omnivore:
            return "circle.grid.cross.fill"
        }
    }
} 