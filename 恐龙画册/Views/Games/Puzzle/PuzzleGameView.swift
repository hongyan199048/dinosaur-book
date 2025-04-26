import SwiftUI

struct PuzzleGameView: View {
    @StateObject private var viewModel: PuzzleGameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPieceId: Int?
    @GestureState private var dragOffset = CGSize.zero
    @GestureState private var rotationAngle = Angle.zero
    
    init(difficulty: PuzzleDifficulty, image: UIImage) {
        _viewModel = StateObject(wrappedValue: PuzzleGameViewModel(difficulty: difficulty, image: image))
    }
    
    var body: some View {
        VStack {
            // 游戏状态栏
            HStack {
                Text("时间: \(Int(viewModel.elapsedTime))秒")
                    .font(.headline)
                Spacer()
                Button("重新开始") {
                    viewModel.resetGame()
                }
            }
            .padding()
            
            // 游戏区域
            GeometryReader { geometry in
                ZStack {
                    // 背景网格
                    GridBackground(gridSize: viewModel.difficulty.gridSize)
                    
                    // 拼图块
                    ForEach(viewModel.pieces) { piece in
                        PuzzlePieceView(piece: piece, size: geometry.size.width / CGFloat(viewModel.difficulty.gridSize))
                            .position(piece.currentPosition)
                            .rotationEffect(piece.rotation)
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset) { value, state, _ in
                                        state = value.translation
                                    }
                                    .onChanged { _ in
                                        selectedPieceId = piece.id
                                    }
                                    .onEnded { value in
                                        let newPosition = CGPoint(
                                            x: piece.currentPosition.x + value.translation.width,
                                            y: piece.currentPosition.y + value.translation.height
                                        )
                                        viewModel.movePiece(piece.id, to: newPosition)
                                        selectedPieceId = nil
                                    }
                            )
                            .simultaneousGesture(
                                RotationGesture()
                                    .updating($rotationAngle) { value, state, _ in
                                        state = value
                                    }
                                    .onEnded { value in
                                        viewModel.rotatePiece(piece.id, by: piece.rotation + value)
                                    }
                            )
                            .offset(selectedPieceId == piece.id ? CGSize(
                                width: dragOffset.width,
                                height: dragOffset.height
                            ) : .zero)
                            .zIndex(selectedPieceId == piece.id ? 1 : 0)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
        .navigationTitle("拼图游戏")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startGame()
        }
        .onDisappear {
            viewModel.stopGame()
        }
        .alert("恭喜!", isPresented: .constant(viewModel.isComplete)) {
            Button("确定") {
                dismiss()
            }
        } message: {
            Text("你完成了拼图！\n用时：\(Int(viewModel.elapsedTime))秒")
        }
    }
}

struct PuzzlePieceView: View {
    let piece: PuzzlePiece
    let size: CGFloat
    
    var body: some View {
        Image(uiImage: piece.image)
            .resizable()
            .frame(width: size, height: size)
            .shadow(radius: 2)
    }
}

struct GridBackground: View {
    let gridSize: Int
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let cellSize = width / CGFloat(gridSize)
                
                // 绘制垂直线
                for i in 0...gridSize {
                    let x = cellSize * CGFloat(i)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                }
                
                // 绘制水平线
                for i in 0...gridSize {
                    let y = cellSize * CGFloat(i)
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
    }
}

#Preview {
    NavigationView {
        PuzzleGameView(difficulty: .easy, image: UIImage(named: "tyrannosaurus_cover") ?? UIImage())
    }
} 