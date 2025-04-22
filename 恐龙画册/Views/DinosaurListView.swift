import SwiftUI

struct DinosaurListView: View {
    @EnvironmentObject private var viewModel: DinosaurViewModel
    @State private var showingFavorites = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 搜索和过滤栏
            VStack(spacing: 8) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                // 收藏夹切换
                Toggle("只显示收藏", isOn: $showingFavorites)
                    .padding(.horizontal)
                    .tint(.yellow)
            }
            .padding(.vertical, 8)
            
            // 过滤器
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // 清除过滤器按钮
                    if viewModel.selectedPeriod != nil || 
                       viewModel.selectedDiet != nil || 
                       viewModel.selectedSize != nil ||
                       !viewModel.searchText.isEmpty {
                        Button(action: viewModel.clearFilters) {
                            Label("清除", systemImage: "xmark.circle.fill")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(20)
                        }
                    }
                    
                    // 时期过滤器
                    ForEach(DinosaurPeriod.allCases, id: \.self) { period in
                        FilterButton(
                            title: period.rawValue,
                            isSelected: viewModel.selectedPeriod == period,
                            action: {
                                viewModel.selectedPeriod = viewModel.selectedPeriod == period ? nil : period
                            }
                        )
                    }
                    
                    // 食性过滤器
                    ForEach(DinosaurDiet.allCases, id: \.self) { diet in
                        FilterButton(
                            title: diet.rawValue,
                            isSelected: viewModel.selectedDiet == diet,
                            action: {
                                viewModel.selectedDiet = viewModel.selectedDiet == diet ? nil : diet
                            }
                        )
                    }
                    
                    // 体型过滤器
                    ForEach(DinosaurSize.allCases, id: \.self) { size in
                        FilterButton(
                            title: size.rawValue,
                            isSelected: viewModel.selectedSize == size,
                            action: {
                                viewModel.selectedSize = viewModel.selectedSize == size ? nil : size
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            // 错误提示
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            // 恐龙列表
            let dinosaurs = showingFavorites ? viewModel.favoriteDinosaurs : viewModel.filteredDinosaurs
            
            if dinosaurs.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: showingFavorites ? "star.slash" : "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text(showingFavorites ? "暂无收藏的恐龙" : "没有找到符合条件的恐龙")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(dinosaurs) { dinosaur in
                    NavigationLink {
                        DinosaurDetailView(dinosaur: dinosaur)
                    } label: {
                        DinosaurRow(
                            dinosaur: dinosaur,
                            isFavorite: viewModel.isFavorite(dinosaur)
                        )
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: { viewModel.toggleFavorite(dinosaur) }) {
                            Label(
                                viewModel.isFavorite(dinosaur) ? "取消收藏" : "收藏",
                                systemImage: viewModel.isFavorite(dinosaur) ? "star.slash.fill" : "star.fill"
                            )
                        }
                        .tint(viewModel.isFavorite(dinosaur) ? .red : .yellow)
                    }
                }
            }
        }
        .navigationTitle("恐龙图鉴")
    }
}

#Preview {
    NavigationView {
        DinosaurListView()
            .environmentObject(DinosaurViewModel())
    }
} 