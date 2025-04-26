import SwiftUI

struct PuzzlePiece: Identifiable {
    let id: Int
    var currentPosition: CGPoint
    let correctPosition: CGPoint
    var rotation: Angle
    let image: UIImage
    
    var isInCorrectPosition: Bool {
        let tolerance: CGFloat = 10
        return abs(currentPosition.x - correctPosition.x) < tolerance &&
               abs(currentPosition.y - correctPosition.y) < tolerance
    }
} 