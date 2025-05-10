import SpriteKit
import SwiftUI

class PuzzleGameScene: SKScene {
    // MARK: - Properties
    private var placedPieces: [SKSpriteNode] = []
    private var selectedPiece: SKSpriteNode?
    private var initialTouchPosition: CGPoint?
    private var initialPiecePosition: CGPoint?
    private var initialPieceRotation: CGFloat?
    private var isRotating = false
    private var lastTouchTime: TimeInterval = 0
    private var doubleTapThreshold: TimeInterval = 0.3
    private var originalImage: UIImage?
    private var difficulty: PuzzleDifficulty = .easy
    private var isGameComplete = false
    private var gridNode: SKShapeNode?
    private var previewNode: SKSpriteNode?
    private var originalPosition: CGPoint?
    private var originalRotation: CGFloat?
    
    // 新增属性
    private var correctPositions: [CGPoint] = []
    private var snapThreshold: CGFloat {
        difficulty.snapThreshold
    }
    
    // 游戏状态回调
    var onGameComplete: (() -> Void)?
    var onPieceMoved: (() -> Void)?
    var onPiecePlaced: ((Int) -> Void)?
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        setupPhysicsWorld()
        setupGrid()
    }
    
    private func setupPhysicsWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    private func setupGrid() {
        gridNode?.removeFromParent()
        gridNode = SKShapeNode(rectOf: size)
        gridNode?.strokeColor = .gray
        gridNode?.lineWidth = 1
        gridNode?.alpha = 0.3
        gridNode?.zPosition = -1
        addChild(gridNode!)
    }
    
    // MARK: - Game Setup
    func setupGame(with image: UIImage, difficulty: PuzzleDifficulty) {
        self.originalImage = image
        self.difficulty = difficulty
        
        // 清除现有拼图块
        placedPieces.forEach { $0.removeFromParent() }
        placedPieces.removeAll()
        correctPositions.removeAll()
        
        // 设置预览图
        setupPreviewImage(image)
        
        // 计算正确位置
        calculateCorrectPositions()
    }
    
    private func calculateCorrectPositions() {
        let gridSize = difficulty.gridSize
        let pieceSize = CGSize(
            width: size.width / CGFloat(gridSize),
            height: size.height / CGFloat(gridSize)
        )
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let position = calculatePiecePosition(
                    at: CGPoint(x: col, y: row),
                    size: pieceSize
                )
                correctPositions.append(position)
            }
        }
    }
    
    private func setupPreviewImage(_ image: UIImage) {
        previewNode?.removeFromParent()
        
        let texture = SKTexture(image: image)
        previewNode = SKSpriteNode(texture: texture)
        previewNode?.size = size
        previewNode?.alpha = 0.1
        previewNode?.zPosition = -2
        addChild(previewNode!)
    }
    
    private func createPuzzlePieces(from image: UIImage) {
        let gridSize = difficulty.gridSize
        let pieceSize = CGSize(
            width: size.width / CGFloat(gridSize),
            height: size.height / CGFloat(gridSize)
        )
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let piece = createPuzzlePiece(
                    at: CGPoint(x: col, y: row),
                    size: pieceSize,
                    image: image,
                    gridSize: gridSize,
                    row: row,
                    col: col
                )
                placedPieces.append(piece)
                addChild(piece)
                
                // 保存正确位置
                let correctPosition = calculatePiecePosition(at: CGPoint(x: col, y: row), size: pieceSize)
                correctPositions.append(correctPosition)
            }
        }
        
        // 随机打乱拼图块位置
        shufflePieces()
    }
    
    private func createPuzzlePiece(at position: CGPoint, size: CGSize, image: UIImage, gridSize: Int, row: Int, col: Int) -> SKSpriteNode {
        let texture = SKTexture(image: image)
        // 计算每个小块在大图中的 rect（归一化坐标）
        let x = CGFloat(col) / CGFloat(gridSize)
        let y = CGFloat(row) / CGFloat(gridSize)
        let w = 1.0 / CGFloat(gridSize)
        let h = 1.0 / CGFloat(gridSize)
        let rect = CGRect(x: x, y: y, width: w, height: h)
        let pieceTexture = SKTexture(rect: rect, in: texture)
        let piece = SKSpriteNode(texture: pieceTexture, size: size)
        piece.position = calculatePiecePosition(at: position, size: size)
        // 设置物理体
        let physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = true
        physicsBody.categoryBitMask = PhysicsCategory.piece
        physicsBody.contactTestBitMask = PhysicsCategory.piece
        physicsBody.collisionBitMask = PhysicsCategory.piece
        piece.physicsBody = physicsBody
        // 添加用户数据
        piece.userData = NSMutableDictionary()
        piece.userData?.setValue(row * gridSize + col, forKey: "id")
        return piece
    }
    
    private func calculatePiecePosition(at gridPosition: CGPoint, size: CGSize) -> CGPoint {
        let x = (gridPosition.x * size.width) + (size.width / 2)
        let y = (gridPosition.y * size.height) + (size.height / 2)
        return CGPoint(x: x, y: y)
    }
    
    private func shufflePieces() {
        placedPieces.forEach { piece in
            let randomX = CGFloat.random(in: 0...size.width)
            let randomY = CGFloat.random(in: 0...size.height)
            piece.position = CGPoint(x: randomX, y: randomY)
            // 只允许0/90/180/270度
            let randomQuarter = Int.random(in: 0..<4)
            piece.zRotation = CGFloat(randomQuarter) * (.pi / 2)
            // 添加随机动画
            let scale = SKAction.sequence([
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ])
            piece.run(scale)
        }
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let currentTime = touch.timestamp
        if currentTime - lastTouchTime < doubleTapThreshold {
            if let piece = atPoint(location) as? SKSpriteNode {
                rotatePiece(piece)
            }
            lastTouchTime = 0
            return
        }
        lastTouchTime = currentTime
        if let piece = atPoint(location) as? SKSpriteNode {
            selectedPiece = piece
            initialTouchPosition = location
            initialPiecePosition = piece.position
            initialPieceRotation = piece.zRotation
            isRotating = false
            // 拖动时禁用物理体
            piece.physicsBody?.isDynamic = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              let piece = selectedPiece,
              let initialTouch = initialTouchPosition,
              let initialPosition = initialPiecePosition else { return }
        
        let location = touch.location(in: self)
        
        // 检查是否是旋转手势
        if !isRotating {
            let touchDistance = hypot(location.x - initialTouch.x, location.y - initialTouch.y)
            if touchDistance > 20 {
                isRotating = true
            }
        }
        
        if isRotating {
            // 旋转处理
            let center = piece.position
            let angle1 = atan2(initialTouch.y - center.y, initialTouch.x - center.x)
            let angle2 = atan2(location.y - center.y, location.x - center.x)
            let rotation = angle2 - angle1
            
            if let initialRotation = initialPieceRotation {
                piece.zRotation = initialRotation + rotation
            }
        } else {
            // 移动处理
            piece.position = CGPoint(
                x: initialPosition.x + (location.x - initialTouch.x),
                y: initialPosition.y + (location.y - initialTouch.y)
            )
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let piece = selectedPiece else { return }
        // 检查是否在正确位置
        if let id = piece.userData?.value(forKey: "id") as? Int,
           id < correctPositions.count {
            let correctPosition = correctPositions[id]
            let distance = hypot(piece.position.x - correctPosition.x,
                               piece.position.y - correctPosition.y)
            if distance < snapThreshold {
                let moveAction = SKAction.move(to: correctPosition, duration: 0.2)
                moveAction.timingMode = .easeOut
                piece.run(moveAction)
                SoundManager.shared.playSound(.puzzleComplete)
                onPiecePlaced?(id)
                if checkCompletion() {
                    isGameComplete = true
                    onGameComplete?()
                }
            }
        }
        // 松手后恢复物理体
        piece.physicsBody?.isDynamic = true
        selectedPiece = nil
        initialTouchPosition = nil
        initialPiecePosition = nil
        initialPieceRotation = nil
        isRotating = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    private func rotatePiece(_ piece: SKSpriteNode) {
        let rotateAction = SKAction.rotate(byAngle: .pi/2, duration: 0.2)
        piece.run(rotateAction)
        SoundManager.shared.playSound(.puzzleSelect)
    }
    
    private func checkCompletion() -> Bool {
        for (index, piece) in placedPieces.enumerated() {
            guard index < correctPositions.count else { continue }
            let correctPosition = correctPositions[index]
            let distance = hypot(piece.position.x - correctPosition.x,
                               piece.position.y - correctPosition.y)
            
            if distance > snapThreshold {
                return false
            }
            
            // 检查旋转角度
            let rotation = piece.zRotation.truncatingRemainder(dividingBy: .pi * 2)
            if abs(rotation) > 0.1 {
                return false
            }
        }
        return true
    }
    
    // MARK: - Game Controls
    func resetGame() {
        // 移除所有已放置的拼图块
        placedPieces.forEach { $0.removeFromParent() }
        placedPieces.removeAll()
        
        // 重新初始化游戏
        if let image = originalImage {
            setupGame(with: image, difficulty: difficulty)
        }
    }
    
    func togglePreview() {
        previewNode?.alpha = previewNode?.alpha == 0.1 ? 0 : 0.1
    }
    
    func toggleGrid() {
        gridNode?.alpha = gridNode?.alpha == 0.3 ? 0 : 0.3
    }
    
    // MARK: - Piece Placement
    func placePiece(_ piece: PuzzlePiece, at position: CGPoint) {
        guard let image = originalImage else { return }
        
        // 计算拼图块ID
        let pieceId = Int(piece.gridPosition.y) * difficulty.gridSize + Int(piece.gridPosition.x)
        
        // 检查是否已经存在相同ID的拼图块
        let existingPiece = placedPieces.first { node in
            guard let nodeId = node.userData?.value(forKey: "id") as? Int else {
                return false
            }
            return nodeId == pieceId
        }
        
        if let existingPiece = existingPiece {
            // 如果存在，更新位置和旋转
            existingPiece.position = position
            existingPiece.zRotation = piece.rotation.radians
            return
        }
        
        let gridSize = difficulty.gridSize
        let pieceSize = CGSize(
            width: size.width / CGFloat(gridSize),
            height: size.height / CGFloat(gridSize)
        )
        
        let spriteNode = createPuzzlePiece(
            at: CGPoint(x: piece.gridPosition.x, y: piece.gridPosition.y),
            size: pieceSize,
            image: image,
            gridSize: gridSize,
            row: Int(piece.gridPosition.y),
            col: Int(piece.gridPosition.x)
        )
        
        spriteNode.position = position
        spriteNode.zRotation = piece.rotation.radians
        placedPieces.append(spriteNode)
        addChild(spriteNode)
        
        // 检查是否在正确位置
        checkPiecePlacement(spriteNode)
    }
    
    private func checkPiecePlacement(_ piece: SKSpriteNode) {
        guard let id = piece.userData?.value(forKey: "id") as? Int,
              id < correctPositions.count else { return }
        
        let correctPosition = correctPositions[id]
        let distance = hypot(piece.position.x - correctPosition.x,
                           piece.position.y - correctPosition.y)
        
        if distance < snapThreshold {
            let moveAction = SKAction.move(to: correctPosition, duration: 0.2)
            moveAction.timingMode = .easeOut
            piece.run(moveAction)
            SoundManager.shared.playSound(.puzzleComplete)
            onPiecePlaced?(id)
            
            if checkCompletion() {
                isGameComplete = true
                onGameComplete?()
            }
        }
    }
}

// MARK: - Physics Categories
struct PhysicsCategory {
    static let piece: UInt32 = 0x1 << 0
}

// MARK: - SKPhysicsContactDelegate
extension PuzzleGameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 处理碰撞
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if let nodeA = bodyA.node as? SKSpriteNode,
           let nodeB = bodyB.node as? SKSpriteNode {
            // 可以在这里添加碰撞效果
            _ = nodeA
            _ = nodeB
        }
    }
}

// MARK: - Helper Extensions
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
} 