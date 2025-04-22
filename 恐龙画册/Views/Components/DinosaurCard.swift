import SwiftUI

struct DinosaurCard: View {
    let dinosaur: Dinosaur
    let isFavorite: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image("\(dinosaur.name)_cover")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                
                if isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dinosaur.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(dinosaur.scientificName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    Text(dinosaur.diet.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue.opacity(0.1))
                        )
                    
                    Spacer()
                    
                    Text(String(format: "%.1fm", dinosaur.length))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview("Dinosaur Card") {
    DinosaurCard(dinosaur: Dinosaur.allDinosaurs[0], isFavorite: false)
        .padding()
} 