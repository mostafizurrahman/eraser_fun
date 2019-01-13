//
//  EraserView.swift
//  eraser_fun
//
//  Created by Mostafizur Rahman on 13/1/19.
//  Copyright © 2019 Mostafizur Rahman. All rights reserved.
//

import UIKit

class EraserView: UIView {
    
    
    var sourceImage:UIImage?
    var blackImage:UIImage?
    var useBlackWhite = true
    let drawingContext = CIContext.init(options: [:])
    var imageWidth:Int = 0
    var imageHeight:Int = 0
    var totalPixel:Int = 0
    var drawRect:CGRect = .zero
    var blackWhiteContext:CGContext!
    var blackWhiteData: UnsafeMutablePointer<UInt32>!
    var scale_x:CGFloat = 0.0
    var scale_y:CGFloat = 0.0
    
    
    
    fileprivate func createPixelMap(){
        guard let imagePath = Bundle.main.path(forResource: "love", ofType: "png") else {
            return
        }
        self.sourceImage = UIImage.init(contentsOfFile: imagePath)
        
        guard let image = self.sourceImage,
            let filter = CIFilter(name: "CIColorMonochrome"),
            let cgimage = image.cgImage else {
                return
        }
        let ciimage = CIImage.init(cgImage: cgimage)
        filter.setValue(ciimage, forKey: kCIInputImageKey)
        guard let __bwimage = filter.value(forKey: kCIOutputImageKey) as? CIImage else {
            return
        }
        guard let outputBWImage = self.drawingContext.createCGImage(__bwimage, from: __bwimage.extent) else {
            return
        }
        self.blackImage = UIImage.init(cgImage: outputBWImage)
        
        
        guard let bwCGImage = self.blackImage?.cgImage else {
            return
        }
        self.imageWidth = bwCGImage.width
        self.imageHeight = bwCGImage.height
        self.drawRect.size.width = CGFloat(self.imageWidth)
        self.drawRect.size.height = CGFloat(self.imageHeight)
        self.scale_x = self.drawRect.size.width / self.bounds.width
        self.scale_y = self.drawRect.size.height / self.bounds.height
        self.totalPixel = self.imageHeight * self.imageWidth
        let bitsPerComponent = 8
        let bytesPerRow = 4 * self.imageWidth
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue |
            CGImageAlphaInfo.premultipliedFirst.rawValue
        self.blackWhiteContext = CGContext(data: nil,
                                           width: self.imageWidth ,
                                           height: self.imageHeight ,
                                           bitsPerComponent: bitsPerComponent,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo)
        if let __data = self.blackWhiteContext.data {
            self.blackWhiteData = __data.bindMemory(to: UInt32.self, capacity: totalPixel * 4)
        }
        self.blackWhiteContext.draw(bwCGImage, in: self.drawRect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createPixelMap()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.useBlackWhite {
            self.useBlackWhite = false
            if let image_view = self.viewWithTag(10101) as? UIImageView {
                if image_view.image == nil {
                    image_view.image = self.sourceImage
                }
            }
        }
        
        if let __bw_view = self.viewWithTag(10111) as? UIImageView {
            if let image = self.blackWhiteContext.makeImage() {
                let __uiimage = UIImage(cgImage: image)
                __bw_view.image = __uiimage
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.removePixels(InTouches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.removePixels(InTouches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.removePixels(InTouches: touches)
    }
    
    fileprivate func removePixels(InTouches touches: Set<UITouch>){
        if let touch = touches.first {
            DispatchQueue.global().async {
                
                let position = touch.location(in: self)
                var origin_x = Int(position.x * self.scale_x - 20.0)
                var origin_y = Int(position.y * self.scale_y - 20.0)
                var dimension:Int = Int(40 * self.scale_x)
                
                if origin_x < 0 {
                    dimension = 20
                    origin_x = 0
                }
                
                if origin_y < 0 {
                    dimension = 20
                    origin_y = 0
                }
                for x in origin_x...origin_x+dimension-1 {
                    for y in origin_y...origin_y+dimension-1 {
                        
                        
                        let index = (self.imageWidth * y) + x
                        
                            let pointer = self.blackWhiteData.advanced(by: index )
                            pointer.pointee = 0
                    }
                }
                DispatchQueue.main.async {
                    self.setNeedsDisplay()
                }
            }
            
            
        }
    }
}
