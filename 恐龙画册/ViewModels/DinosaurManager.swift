import Foundation
import SwiftUI

@MainActor
final class DinosaurManager: ObservableObject {
    @Published private(set) var dinosaurs: [Dinosaur]
    private let savePath: URL
    
    init() {
        self.dinosaurs = Dinosaur.allDinosaurs
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        self.savePath = paths[0].appendingPathComponent("favorites.json")
        
        loadFavorites()
    }
    
    func toggleFavorite(for dinosaur: Dinosaur) {
        if let index = dinosaurs.firstIndex(where: { $0.id == dinosaur.id }) {
            var updatedDinosaur = dinosaurs[index]
            updatedDinosaur.isFavorite.toggle()
            dinosaurs[index] = updatedDinosaur
            saveFavorites()
        }
    }
    
    // 更新恐龙列表
    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(dinosaurs)
            try data.write(to: savePath, options: .atomicWrite)
        } catch {
            print("Error saving favorites: \(error.localizedDescription)")
        }
    }
    
    private func loadFavorites() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoder = JSONDecoder()
            dinosaurs = try decoder.decode([Dinosaur].self, from: data)
        } catch {
            // 如果加载失败，使用默认数据
            dinosaurs = Dinosaur.allDinosaurs
        }
    }
    
    var favoriteDinosaurs: [Dinosaur] {
        dinosaurs.filter { $0.isFavorite }
    }
    
    func filteredDinosaurs(
        searchText: String = "",
        period: DinosaurPeriod? = nil,
        diet: DinosaurDiet? = nil,
        size: DinosaurSize? = nil,
        favoritesOnly: Bool = false
    ) -> [Dinosaur] {
        var result = dinosaurs
        
        if favoritesOnly {
            result = favoriteDinosaurs
        }
        
        if let period = period {
            result = result.filter { $0.period == period }
        }
        
        if let diet = diet {
            result = result.filter { $0.diet == diet }
        }
        
        if let size = size {
            result = result.filter { $0.size == size }
        }
        
        if !searchText.isEmpty {
            result = result.filter { dinosaur in
                dinosaur.name.localizedCaseInsensitiveContains(searchText) ||
                dinosaur.scientificName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
} 