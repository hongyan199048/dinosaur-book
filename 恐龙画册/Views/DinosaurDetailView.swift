import SwiftUI
import MapKit
import AVKit
import WebKit

struct DinosaurDetailView: View {
    let dinosaur: Dinosaur
    @EnvironmentObject private var viewModel: DinosaurViewModel
    @State private var region: MKCoordinateRegion
    
    init(dinosaur: Dinosaur) {
        self.dinosaur = dinosaur
        if let firstCoordinate = dinosaur.mapCoordinates?.first {
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: firstCoordinate.latitude,
                    longitude: firstCoordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            ))
        } else {
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            ))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 视频播放器
                if let videoURL = dinosaur.videoURL {
                    BilibiliVideoPlayer(videoURL: videoURL)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } else {
                    // 如果没有视频，显示图片
                    AsyncImage(url: dinosaur.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // 基本信息
                    VStack(alignment: .leading, spacing: 8) {
                        Text(dinosaur.scientificName)
                            .font(.title2)
                            .italic()
                            .foregroundColor(.secondary)
                        
                        // 特征标签
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                FeatureTag(text: dinosaur.period.rawValue, color: .blue)
                                FeatureTag(text: dinosaur.diet.rawValue, color: .green)
                                FeatureTag(text: dinosaur.size.rawValue, color: sizeColor)
                                FeatureTag(text: dinosaur.classification.rawValue, color: .purple)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 尺寸信息
                    VStack(alignment: .leading, spacing: 8) {
                        Text("尺寸信息")
                            .font(.headline)
                        HStack {
                            InfoRow(title: "长度", value: "\(String(format: "%.1f", dinosaur.length))米")
                            InfoRow(title: "高度", value: "\(String(format: "%.1f", dinosaur.height))米")
                            InfoRow(title: "体重", value: "\(String(format: "%.1f", dinosaur.weight))吨")
                        }
                    }
                    
                    Divider()
                    
                    // 分布地图
                    if let coordinates = dinosaur.mapCoordinates {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("分布区域")
                                .font(.headline)
                            Map(coordinateRegion: $region, annotationItems: coordinates) { coordinate in
                                MapMarker(coordinate: CLLocationCoordinate2D(
                                    latitude: coordinate.latitude,
                                    longitude: coordinate.longitude
                                ), tint: .red)
                            }
                            .frame(height: 200)
                            .cornerRadius(12)
                        }
                    }
                    
                    Divider()
                    
                    // 发现信息
                    VStack(alignment: .leading, spacing: 8) {
                        Text("发现信息")
                            .font(.headline)
                        InfoRow(title: "发现年份", value: "\(dinosaur.discoveryYear)")
                        InfoRow(title: "发现者", value: dinosaur.discoverer)
                    }
                    
                    Divider()
                    
                    // 特征
                    VStack(alignment: .leading, spacing: 8) {
                        Text("主要特征")
                            .font(.headline)
                        ForEach(dinosaur.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 相关物种
                    VStack(alignment: .leading, spacing: 8) {
                        Text("相关物种")
                            .font(.headline)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(dinosaur.relatedSpecies, id: \.self) { species in
                                    Text(species)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 详细描述
                    Text(dinosaur.description)
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(dinosaur.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite(dinosaur)
                } label: {
                    Image(systemName: viewModel.isFavorite(dinosaur) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
    
    private var sizeColor: Color {
        switch dinosaur.size {
        case .small:
            return .green
        case .medium:
            return .blue
        case .large:
            return .orange
        case .huge:
            return .red
        }
    }
}

struct FeatureTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(16)
    }
}

struct BilibiliVideoPlayer: UIViewRepresentable {
    let videoURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let bvID = extractBVID(from: videoURL) {
            let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }
                    
                    html, body {
                        width: 100%;
                        height: 100%;
                        overflow: hidden;
                        background-color: transparent;
                    }
                    
                    .video-container {
                        position: relative;
                        width: 100%;
                        height: 0;
                        padding-bottom: 56.25%; /* 16:9 */
                        background-color: transparent;
                    }
                    
                    iframe {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        border: none;
                    }
                </style>
            </head>
            <body>
                <div class="video-container">
                    <iframe src="https://player.bilibili.com/player.html?bvid=\(bvID)&autoplay=0&high_quality=1&danmaku=0"
                            scrolling="no"
                            frameborder="0"
                            sandbox="allow-top-navigation allow-same-origin allow-forms allow-scripts"
                            allowfullscreen>
                    </iframe>
                </div>
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: BilibiliVideoPlayer
        
        init(_ parent: BilibiliVideoPlayer) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 视频加载完成后的处理
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Video loading error: \(error.localizedDescription)")
        }
    }
    
    private func extractBVID(from url: URL) -> String? {
        let urlString = url.absoluteString
        // 匹配BV开头的ID，支持更多格式
        if let range = urlString.range(of: "BV[A-Za-z0-9]+", options: .regularExpression) {
            return String(urlString[range])
        }
        return nil
    }
}

#Preview {
    NavigationView {
        DinosaurDetailView(
            dinosaur: Dinosaur.allDinosaurs[0]
        )
        .environmentObject(DinosaurViewModel())
    }
} 
