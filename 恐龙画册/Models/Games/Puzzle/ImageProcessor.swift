import UIKit

class ImageProcessor {
    static func splitImage(_ image: UIImage, into gridSize: Int) -> [[UIImage]] {
        let width = image.size.width
        let height = image.size.height
        let tileWidth = width / CGFloat(gridSize)
        let tileHeight = height / CGFloat(gridSize)
        
        var result: [[UIImage]] = []
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: tileWidth, height: tileHeight), false, image.scale)
        
        for row in 0..<gridSize {
            var rowImages: [UIImage] = []
            for column in 0..<gridSize {
                let drawRect = CGRect(x: -CGFloat(column) * tileWidth,
                                    y: -CGFloat(row) * tileHeight,
                                    width: width,
                                    height: height)
                
                image.draw(in: drawRect)
                let tileImage = UIGraphicsGetImageFromCurrentImageContext()!
                rowImages.append(tileImage)
                
                // 清除上下文，准备绘制下一个
                UIGraphicsGetCurrentContext()?.clear(CGRect(x: 0, y: 0, width: tileWidth, height: tileHeight))
            }
            result.append(rowImages)
        }
        
        UIGraphicsEndImageContext()
        return result
    }
    
    static func prepareImage(_ image: UIImage) -> UIImage {
        let targetSize = CGSize(width: 600, height: 600) // 使用固定大小以确保性能
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

 