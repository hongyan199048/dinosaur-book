import SwiftUI

class DinosaurViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedPeriod: DinosaurPeriod?
    @Published var selectedDiet: DinosaurDiet?
    @Published var selectedSize: DinosaurSize?
    @Published var errorMessage: String?
    @Published private var favorites: Set<UUID> = []
    
    private let allDinosaurs = Dinosaur.allDinosaurs
    
    var filteredDinosaurs: [Dinosaur] {
        var result = allDinosaurs
        
        // 应用搜索过滤
        if !searchText.isEmpty {
            result = result.filter { dinosaur in
                dinosaur.name.localizedCaseInsensitiveContains(searchText) ||
                dinosaur.scientificName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // 应用时期过滤
        if let period = selectedPeriod {
            result = result.filter { $0.period == period }
        }
        
        // 应用食性过滤
        if let diet = selectedDiet {
            result = result.filter { $0.diet == diet }
        }
        
        // 应用体型过滤
        if let size = selectedSize {
            result = result.filter { $0.size == size }
        }
        
        return result
    }
    
    var favoriteDinosaurs: [Dinosaur] {
        allDinosaurs.filter { favorites.contains($0.id) }
    }
    
    func isFavorite(_ dinosaur: Dinosaur) -> Bool {
        favorites.contains(dinosaur.id)
    }
    
    func toggleFavorite(_ dinosaur: Dinosaur) {
        if favorites.contains(dinosaur.id) {
            favorites.remove(dinosaur.id)
        } else {
            favorites.insert(dinosaur.id)
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedPeriod = nil
        selectedDiet = nil
        selectedSize = nil
    }
} 