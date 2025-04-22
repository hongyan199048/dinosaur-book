import Foundation
import SwiftUI

@MainActor
final class DinosaurManager: ObservableObject {
    @Published private(set) var dinosaurs: [Dinosaur] = []
    @Published private(set) var filteredDinosaurs: [Dinosaur] = []
    @Published var searchText: String = ""
    @Published var selectedPeriod: DinosaurPeriod?
    @Published var selectedDiet: Diet?
    @Published var selectedSize: Size?
    
    init() {
        loadDinosaurs()
    }
    
    private func loadDinosaurs() {
        dinosaurs = Dinosaur.allDinosaurs
        filteredDinosaurs = dinosaurs
    }
    
    func filterDinosaurs() {
        filteredDinosaurs = dinosaurs.filter { dinosaur in
            let matchesSearch = searchText.isEmpty || 
                dinosaur.name.localizedCaseInsensitiveContains(searchText) ||
                dinosaur.scientificName.localizedCaseInsensitiveContains(searchText)
            
            let matchesPeriod = selectedPeriod == nil || dinosaur.period == selectedPeriod
            let matchesDiet = selectedDiet == nil || dinosaur.diet == selectedDiet
            let matchesSize = selectedSize == nil || dinosaur.size == selectedSize
            
            return matchesSearch && matchesPeriod && matchesDiet && matchesSize
        }
    }
    
    func getDinosaursByPeriod(_ period: DinosaurPeriod) -> [Dinosaur] {
        return dinosaurs.filter { $0.period == period }
    }
    
    func getDinosaursByDiet(_ diet: Diet) -> [Dinosaur] {
        return dinosaurs.filter { $0.diet == diet }
    }
    
    func getDinosaursBySize(_ size: Size) -> [Dinosaur] {
        return dinosaurs.filter { $0.size == size }
    }
    
    func getDinosaursByClassification(_ classification: Dinosaur.Classification) -> [Dinosaur] {
        return dinosaurs.filter { $0.classification == classification }
    }
    
    func getDinosaursByDistribution(_ distribution: String) -> [Dinosaur] {
        return dinosaurs.filter { $0.distribution == distribution }
    }
    
    func getDinosaursByDiscoveryYear(_ year: Int) -> [Dinosaur] {
        return dinosaurs.filter { $0.discoveryYear == year }
    }
    
    func getDinosaursByDiscoverer(_ discoverer: String) -> [Dinosaur] {
        return dinosaurs.filter { $0.discoverer == discoverer }
    }
    
    func getDinosaursWithVideo() -> [Dinosaur] {
        return dinosaurs.filter { $0.videoURL != nil }
    }
    
    func getDinosaursWithMap() -> [Dinosaur] {
        return dinosaurs.filter { $0.mapCoordinates != nil }
    }
    
    func getDinosaursByFeature(_ feature: String) -> [Dinosaur] {
        return dinosaurs.filter { $0.features.contains(feature) }
    }
    
    func getRelatedSpecies(for dinosaur: Dinosaur) -> [Dinosaur] {
        return dinosaurs.filter { dinosaur.relatedSpecies.contains($0.name) }
    }
    
    func getDinosaursInSizeRange(min: Double, max: Double) -> [Dinosaur] {
        return dinosaurs.filter { $0.length >= min && $0.length <= max }
    }
    
    func getDinosaursInWeightRange(min: Double, max: Double) -> [Dinosaur] {
        return dinosaurs.filter { $0.weight >= min && $0.weight <= max }
    }
    
    func getDinosaursInHeightRange(min: Double, max: Double) -> [Dinosaur] {
        return dinosaurs.filter { $0.height >= min && $0.height <= max }
    }
    
    func getDinosaursByLocation(latitude: Double, longitude: Double, radius: Double) -> [Dinosaur] {
        return dinosaurs.filter { dinosaur in
            guard let coordinates = dinosaur.mapCoordinates else { return false }
            return coordinates.contains { coordinate in
                let distance = sqrt(
                    pow(coordinate.latitude - latitude, 2) +
                    pow(coordinate.longitude - longitude, 2)
                )
                return distance <= radius
            }
        }
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
} 