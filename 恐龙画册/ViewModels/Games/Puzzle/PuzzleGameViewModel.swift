import SwiftUI
import UIKit

class PuzzleGameViewModel: ObservableObject {
    @Published var pieces: [PuzzlePiece] = []
    @Published var isComplete = false
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    
    let difficulty: PuzzleDifficulty
    let image: UIImage
    private var gridSize: Int { difficulty.gridSize }
    
    init(difficulty: PuzzleDifficulty, image: UIImage) {
        self.difficulty = difficulty
        self.image = ImageProcessor.prepareImage(image)
        setupGame()
    }
    
    private func setupGame() {
        // 切割图片
        let tileImages = ImageProcessor.splitImage(image, into: gridSize)
        pieces = []
        
        // 计算每个拼图块的大小
        let tileSize = image.size.width / CGFloat(gridSize)
        
        // 创建拼图块
        for row in 0..<gridSize {
            for column in 0..<gridSize {
                let correctX = tileSize * (CGFloat(column) + 0.5)
                let correctY = tileSize * (CGFloat(row) + 0.5)
                let correctPosition = CGPoint(x: correctX, y: correctY)
                
                // 随机位置（在游戏区域内）
                let randomX = CGFloat.random(in: tileSize/2...image.size.width-tileSize/2)
                let randomY = CGFloat.random(in: tileSize/2...image.size.width-tileSize/2)
                let randomPosition = CGPoint(x: randomX, y: randomY)
                
                // 随机旋转角度
                let randomRotation = Angle(degrees: Double.random(in: 0...360))
                
                let piece = PuzzlePiece(
                    id: row * gridSize + column,
                    currentPosition: randomPosition,
                    correctPosition: correctPosition,
                    rotation: randomRotation,
                    image: tileImages[row][column]
                )
                pieces.append(piece)
            }
        }
    }
    
    func startGame() {
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }
    
    func stopGame() {
        timer?.invalidate()
        timer = nil
    }
    
    func movePiece(_ id: Int, to position: CGPoint) {
        guard let index = pieces.firstIndex(where: { $0.id == id }) else { return }
        pieces[index].currentPosition = position
        checkCompletion()
    }
    
    func rotatePiece(_ id: Int, by angle: Angle) {
        guard let index = pieces.firstIndex(where: { $0.id == id }) else { return }
        pieces[index].rotation = angle
    }
    
    func checkCompletion() {
        isComplete = pieces.allSatisfy { $0.isInCorrectPosition }
        if isComplete {
            stopGame()
        }
    }
    
    func resetGame() {
        stopGame()
        setupGame()
        startGame()
    }
    
    deinit {
        stopGame()
    }
} 