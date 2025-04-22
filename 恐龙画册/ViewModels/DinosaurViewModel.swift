import SwiftUI

@MainActor
class DinosaurViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedPeriod: DinosaurPeriod?
    @Published var selectedDiet: Diet?
    @Published var selectedSize: Size?
    @Published var errorMessage: String?
    @Published var favorites: Set<UUID> = []
    
    private let manager = DinosaurManager()
    
    var filteredDinosaurs: [Dinosaur] {
        manager.filteredDinosaurs
    }
    
    var favoriteDinosaurs: [Dinosaur] {
        manager.dinosaurs.filter { favorites.contains($0.id) }
    }
    
    func filterDinosaurs() {
        manager.searchText = searchText
        manager.selectedPeriod = selectedPeriod
        manager.selectedDiet = selectedDiet
        manager.selectedSize = selectedSize
        manager.filterDinosaurs()
    }
    
    func toggleFavorite(_ dinosaur: Dinosaur) {
        if favorites.contains(dinosaur.id) {
            favorites.remove(dinosaur.id)
        } else {
            favorites.insert(dinosaur.id)
        }
    }
    
    func isFavorite(_ dinosaur: Dinosaur) -> Bool {
        favorites.contains(dinosaur.id)
    }
    
    func clearFilters() {
        searchText = ""
        selectedPeriod = nil
        selectedDiet = nil
        selectedSize = nil
    }
} 