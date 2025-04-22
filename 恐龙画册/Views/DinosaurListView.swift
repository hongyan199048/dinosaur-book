import SwiftUI

struct DinosaurListView: View {
    @StateObject private var viewModel = DinosaurViewModel()
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack {
                searchAndFilterSection
                
                if showingFilters {
                    FilterView(
                        selectedPeriod: $viewModel.selectedPeriod,
                        selectedDiet: $viewModel.selectedDiet,
                        selectedSize: $viewModel.selectedSize
                    )
                    .padding()
                }
                
                dinosaurGrid
            }
            .navigationTitle("恐龙画册")
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                viewModel.filterDinosaurs()
            }
            .onChange(of: viewModel.selectedPeriod) { oldValue, newValue in
                viewModel.filterDinosaurs()
            }
            .onChange(of: viewModel.selectedDiet) { oldValue, newValue in
                viewModel.filterDinosaurs()
            }
            .onChange(of: viewModel.selectedSize) { oldValue, newValue in
                viewModel.filterDinosaurs()
            }
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            Button {
                showingFilters.toggle()
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("筛选")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(showingFilters ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(showingFilters ? .white : .primary)
            }
            .padding(.horizontal)
        }
    }
    
    private var dinosaurGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(viewModel.filteredDinosaurs) { dinosaur in
                    NavigationLink(destination: DinosaurDetailView(dinosaur: dinosaur)) {
                        DinosaurCard(
                            dinosaur: dinosaur,
                            isFavorite: viewModel.isFavorite(dinosaur)
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct FilterView: View {
    @Binding var selectedPeriod: DinosaurPeriod?
    @Binding var selectedDiet: Diet?
    @Binding var selectedSize: Size?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("筛选条件")
                .font(.headline)
            
            periodFilter
            dietFilter
            sizeFilter
        }
    }
    
    private var periodFilter: some View {
        FilterSection(title: "时期", items: DinosaurPeriod.allCases) { period in
            selectedPeriod = period
        } selectedItem: {
            selectedPeriod
        }
    }
    
    private var dietFilter: some View {
        FilterSection(title: "食性", items: Diet.allCases) { diet in
            selectedDiet = diet
        } selectedItem: {
            selectedDiet
        }
    }
    
    private var sizeFilter: some View {
        FilterSection(title: "体型", items: Size.allCases) { size in
            selectedSize = size
        } selectedItem: {
            selectedSize
        }
    }
}

struct FilterSection<T: Hashable>: View {
    let title: String
    let items: [T]
    let action: (T?) -> Void
    let selectedItem: () -> T?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach([nil] + items, id: \.self) { item in
                        FilterChip(
                            title: (item as? (any RawRepresentable))?.rawValue as? String ?? "全部",
                            isSelected: selectedItem() == item
                        ) {
                            action(item)
                        }
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

#Preview {
    DinosaurListView()
} 