import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        setupAudioPlayers()
    }
    
    private func setupAudioPlayers() {
        // 加载音效文件
        if let correctPath = Bundle.main.path(forResource: "correct", ofType: "mp3") {
            audioPlayers["correct"] = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: correctPath))
        }
        
        if let wrongPath = Bundle.main.path(forResource: "wrong", ofType: "mp3") {
            audioPlayers["wrong"] = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: wrongPath))
        }
        
        if let completePath = Bundle.main.path(forResource: "complete", ofType: "mp3") {
            audioPlayers["complete"] = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: completePath))
        }
    }
    
    func playSound(_ name: String) {
        guard let player = audioPlayers[name] else { return }
        player.currentTime = 0
        player.play()
    }
    
    func playCorrectSound() {
        playSound("correct")
    }
    
    func playWrongSound() {
        playSound("wrong")
    }
    
    func playCompleteSound() {
        playSound("complete")
    }
} 