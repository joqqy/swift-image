#if canImport(CoreGraphics)
import CoreGraphics

public enum CGContextCoordinates {
    case original
    case natural
}

public protocol _CGGrayScale {}
public protocol _CGRGBA {}

extension _CGGrayScale {
    public static var _ez_cgColorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceGray()
    }

    public static var _ez_cgBitmapInfo: CGBitmapInfo {
        return CGBitmapInfo()
    }
}

extension _CGRGBA {

    public static var _ez_cgColorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }

    public static var _ez_cgBitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
}

extension UInt8: _CGGrayScale {}
extension UInt16: _CGGrayScale {}
extension Float: _CGGrayScale {}
extension Double: _CGGrayScale {}
extension Bool: _CGGrayScale {}
extension RGBA: _CGRGBA {}
extension PremultipliedRGBA: _CGRGBA {}

public protocol _CGChannel {
    associatedtype _EZ_DirectChannel: _CGDirectChannel, Numeric
}

public protocol _CGDirectChannel: _CGChannel where _EZ_DirectChannel == Self {

}

extension UInt8: _CGDirectChannel {
    public typealias _EZ_DirectChannel = UInt8
}

extension UInt16: _CGDirectChannel {
    public typealias _EZ_DirectChannel = UInt16
}

extension Float: _CGChannel {
    public typealias _EZ_DirectChannel = UInt8
}

extension Double: _CGChannel {
    public typealias _EZ_DirectChannel = UInt8
}

extension Bool: _CGChannel {
    public typealias _EZ_DirectChannel = UInt8
}

public protocol _CGPixel {
    associatedtype _EZ_DirectPixel: _CGDirectPixel

    static var _ez_cgColorSpace: CGColorSpace { get }
    static var _ez_cgBitmapInfo: CGBitmapInfo { get }
}

public protocol _CGDirectPixel: _CGPixel where _EZ_DirectPixel == Self {

}

extension UInt8: _CGDirectPixel {
    public typealias _EZ_DirectPixel = UInt8
}

extension UInt16: _CGDirectPixel {
    public typealias _EZ_DirectPixel = UInt16
}

extension Float: _CGPixel {
    public typealias _EZ_DirectPixel = UInt8
}

extension Double: _CGPixel {
    public typealias _EZ_DirectPixel = UInt8
}

extension Bool: _CGPixel {
    public typealias _EZ_DirectPixel = UInt8
}

extension RGBA: _CGPixel where Channel: _CGChannel {
    public typealias _EZ_DirectPixel = PremultipliedRGBA<Channel._EZ_DirectChannel>
}

extension PremultipliedRGBA: _CGPixel where Channel: _CGChannel {
    public typealias _EZ_DirectPixel = PremultipliedRGBA<Channel._EZ_DirectChannel>
}

extension PremultipliedRGBA: _CGDirectPixel where Channel: _CGDirectChannel {

}

extension Image where Pixel == RGBA<UInt8> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<PremultipliedRGBA<UInt8>>(width: width, height: height, setUp: setUp)
        self = image.map { RGBA<UInt8>($0) }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return Image.generatedCGImage(
            image: self,
            colorSpace: Image<RGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<RGBA<UInt8>>.bitmapInfo,
            maxValue: .max,
            toAdditive: Int.init,
            product: (*) as (Int, Int) -> Int,
            quotient: (/) as (Int, Int) -> Int,
            toOriginal: UInt8.init
        )
    }
}

extension Image where Pixel == RGBA<UInt16> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<PremultipliedRGBA<UInt16>>(width: width, height: height, setUp: setUp)
        self = image.map { RGBA<UInt16>($0) }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return Image.generatedCGImage(
            image: self,
            colorSpace: Image<RGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<RGBA<UInt16>>.bitmapInfo,
            maxValue: .max,
            toAdditive: Int.init,
            product: (*) as (Int, Int) -> Int,
            quotient: (/) as (Int, Int) -> Int,
            toOriginal: UInt16.init
        )
    }
}

extension Image where Pixel == RGBA<Float> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<PremultipliedRGBA<Float>>(width: width, height: height, setUp: setUp)
        self = image.map { RGBA<Float>($0) }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { $0.map { UInt8(clamp($0, lower: 0.0, upper: 1.0) * 255) } }.cgImage
    }
}

extension Image where Pixel == RGBA<Double> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<PremultipliedRGBA<Double>>(width: width, height: height, setUp: setUp)
        self = image.map { RGBA<Double>($0) }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { $0.map { UInt8(clamp($0, lower: 0.0, upper: 1.0) * 255) } }.cgImage
    }
}

extension Image where Pixel == RGBA<Bool> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<RGBA<UInt8>>(width: width, height: height, setUp: setUp)
        self = image.map { $0.map { $0 >= 128 } }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { $0.map { $0 ? (255 as UInt8) : (0 as UInt8) } }.cgImage
    }
}

extension Image where Pixel == PremultipliedRGBA<UInt8> {
    fileprivate static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    fileprivate static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let pixels = [PremultipliedRGBA<UInt8>](repeating: PremultipliedRGBA<UInt8>(red: 0, green: 0, blue: 0, alpha: 0), count: width * height)
        self.init(width: width, height: height, pixels: pixels)
        withCGContext(coordinates: .original, setUp)
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return Image.generatedCGImage(
            image: self,
            colorSpace: Image<PremultipliedRGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt8>>.bitmapInfo,
            componentType: UInt8.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try Image.withGeneratedCGImage(
            image: self,
            colorSpace: Image<PremultipliedRGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt8>>.bitmapInfo,
            body: body,
            componentType: UInt8.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        let width = self.width
        let height = self.height

        precondition(width >= 0)
        precondition(height >= 0)

        let context  = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt8>.size * 8,
            bytesPerRow: MemoryLayout<PremultipliedRGBA<UInt8>>.size * width,
            space: Image<PremultipliedRGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt8>>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5, y: 0.5 - CGFloat(height))
        }

        try body(context)
    }
}

extension Image where Pixel == PremultipliedRGBA<UInt16> {
    fileprivate static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    fileprivate static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let pixels = [PremultipliedRGBA<UInt16>](repeating: PremultipliedRGBA<UInt16>(red: 0, green: 0, blue: 0, alpha: 0), count: width * height)
        self.init(width: width, height: height, pixels: pixels)
        withCGContext(coordinates: .original, setUp)
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return Image.generatedCGImage(
            image: self,
            colorSpace: Image<PremultipliedRGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt16>>.bitmapInfo,
            componentType: UInt16.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try Image.withGeneratedCGImage(
            image: self,
            colorSpace: Image<PremultipliedRGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt16>>.bitmapInfo,
            body: body,
            componentType: UInt16.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        let width = self.width
        let height = self.height

        precondition(width >= 0)
        precondition(height >= 0)

        let context  = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt16>.size * 8,
            bytesPerRow: MemoryLayout<PremultipliedRGBA<UInt16>>.size * width,
            space: Image<PremultipliedRGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt16>>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5, y: 0.5 - CGFloat(height))
        }

        try body(context)
    }
}

extension Image where Pixel == PremultipliedRGBA<Float> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<PremultipliedRGBA<UInt8>>(width: width, height: height, setUp: setUp)
        self = image.map { $0.map { Float($0) / 255 } }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { $0.map { UInt8(clamp($0, lower: 0.0, upper: 1.0) * 255) } }.cgImage
    }
}

extension Image where Pixel == PremultipliedRGBA<Double> {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<PremultipliedRGBA<UInt8>>(width: width, height: height, setUp: setUp)
        self = image.map { $0.map { Double($0) / 255 } }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { $0.map { UInt8(clamp($0, lower: 0.0, upper: 1.0) * 255) } }.cgImage
    }
}

extension Image where Pixel == UInt8 {
    fileprivate static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceGray()
    }
    
    fileprivate static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo()
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let pixels = [UInt8](repeating: .zero, count: width * height)
        self.init(width: width, height: height, pixels: pixels)
        withCGContext(coordinates: .original, setUp)
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return Image.generatedCGImage(
            image: self,
            colorSpace: Image<UInt8>.colorSpace,
            bitmapInfo: Image<UInt8>.bitmapInfo,
            componentType: UInt8.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try Image.withGeneratedCGImage(
            image: self,
            colorSpace: Image<UInt8>.colorSpace,
            bitmapInfo: Image<UInt8>.bitmapInfo,
            body: body,
            componentType: UInt8.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        let width = self.width
        let height = self.height

        precondition(width >= 0)
        precondition(height >= 0)

        let context  = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt8>.size * 8,
            bytesPerRow: MemoryLayout<UInt8>.size * width,
            space: Image<UInt8>.colorSpace,
            bitmapInfo: Image<UInt8>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5, y: 0.5 - CGFloat(height))
        }

        try body(context)
    }
}

extension Image where Pixel == UInt16 {
    fileprivate static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceGray()
    }
    
    fileprivate static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo()
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let pixels = [UInt16](repeating: .zero, count: width * height)
        self.init(width: width, height: height, pixels: pixels)
        withCGContext(coordinates: .original, setUp)
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return Image.generatedCGImage(
            image: self,
            colorSpace: Image<UInt16>.colorSpace,
            bitmapInfo: Image<UInt16>.bitmapInfo,
            componentType: UInt16.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try Image.withGeneratedCGImage(
            image: self,
            colorSpace: Image<UInt16>.colorSpace,
            bitmapInfo: Image<UInt16>.bitmapInfo,
            body: body,
            componentType: UInt16.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        let width = self.width
        let height = self.height

        precondition(width >= 0)
        precondition(height >= 0)

        let context  = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt16>.size * 8,
            bytesPerRow: MemoryLayout<UInt16>.size * width,
            space: Image<UInt16>.colorSpace,
            bitmapInfo: Image<UInt16>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5, y: 0.5 - CGFloat(height))
        }

        try body(context)
    }
}

extension Image where Pixel == Float {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceGray()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo()
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<UInt8>(width: width, height: height, setUp: setUp)
        self = image.map { Float($0) / 255 }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { UInt8(clamp($0, lower: 0.0, upper: 1.0) * 255) }.cgImage
    }
}

extension Image where Pixel == Double {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceGray()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo()
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<UInt8>(width: width, height: height, setUp: setUp)
        self = image.map { Double($0) / 255 }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { UInt8(clamp($0, lower: 0.0, upper: 1.0) * 255) }.cgImage
    }
}

extension Image where Pixel == Bool {
    private static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceGray()
    }
    
    private static var bitmapInfo: CGBitmapInfo {
        return CGBitmapInfo()
    }
    
    private init(width: Int, height: Int, setUp: (CGContext) -> ()) {
        let image = Image<UInt8>(width: width, height: height, setUp: setUp)
        self = image.map { $0 >= 128 }
    }
    
    public init(cgImage: CGImage) {
        let width = cgImage.width
        let height = cgImage.height
        
        self.init(width: width, height: height, setUp: { context in
            let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
            context.draw(cgImage, in: rect)
        })
    }
    
    public var cgImage: CGImage {
        return map { $0 ? 255 as UInt8 : 0 as UInt8 }.cgImage
    }
}

extension ImageSlice where Pixel == PremultipliedRGBA<UInt8> {
    public var cgImage: CGImage {
        return ImageSlice<PremultipliedRGBA<UInt8>>.generatedCGImage(
            slice: self,
            colorSpace: Image<PremultipliedRGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt8>>.bitmapInfo,
            componentType: UInt8.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try ImageSlice<PremultipliedRGBA<UInt8>>.withGeneratedCGImage(
            slice: self,
            colorSpace: Image<PremultipliedRGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt8>>.bitmapInfo,
            body: body,
            componentType: UInt8.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        precondition(width >= 0)
        precondition(height >= 0)

        let data: UnsafeMutablePointer<PremultipliedRGBA<UInt8>> = &self.image.pixels + (yRange.lowerBound * self.image.width + xRange.lowerBound)
        let context  = CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt8>.size * 8,
            bytesPerRow: MemoryLayout<PremultipliedRGBA<UInt8>>.size * self.image.width,
            space: Image<PremultipliedRGBA<UInt8>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt8>>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5 - CGFloat(xRange.lowerBound), y: 0.5 - CGFloat(yRange.lowerBound + height))
        }

        try body(context)
    }
}

extension ImageSlice where Pixel == PremultipliedRGBA<UInt16> {
    public var cgImage: CGImage {
        return ImageSlice<PremultipliedRGBA<UInt16>>.generatedCGImage(
            slice: self,
            colorSpace: Image<PremultipliedRGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt16>>.bitmapInfo,
            componentType: UInt16.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try ImageSlice<PremultipliedRGBA<UInt16>>.withGeneratedCGImage(
            slice: self,
            colorSpace: Image<PremultipliedRGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt16>>.bitmapInfo,
            body: body,
            componentType: UInt16.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        precondition(width >= 0)
        precondition(height >= 0)

        let data: UnsafeMutablePointer<PremultipliedRGBA<UInt16>> = &self.image.pixels + (yRange.lowerBound * self.image.width + xRange.lowerBound)
        let context  = CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt16>.size * 8,
            bytesPerRow: MemoryLayout<PremultipliedRGBA<UInt16>>.size * self.image.width,
            space: Image<PremultipliedRGBA<UInt16>>.colorSpace,
            bitmapInfo: Image<PremultipliedRGBA<UInt16>>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5 - CGFloat(xRange.lowerBound), y: 0.5 - CGFloat(yRange.lowerBound + height))
        }

        try body(context)
    }
}

extension ImageSlice where Pixel == UInt8 {
    public var cgImage: CGImage {
        return ImageSlice<UInt8>.generatedCGImage(
            slice: self,
            colorSpace: Image<UInt8>.colorSpace,
            bitmapInfo: Image<UInt8>.bitmapInfo,
            componentType: UInt8.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try ImageSlice<UInt8>.withGeneratedCGImage(
            slice: self,
            colorSpace: Image<UInt8>.colorSpace,
            bitmapInfo: Image<UInt8>.bitmapInfo,
            body: body,
            componentType: UInt8.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        precondition(width >= 0)
        precondition(height >= 0)

        let data: UnsafeMutablePointer<UInt8> = &self.image.pixels + (yRange.lowerBound * self.image.width + xRange.lowerBound)
        let context  = CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt8>.size * 8,
            bytesPerRow: MemoryLayout<UInt8>.size * self.image.width,
            space: Image<UInt8>.colorSpace,
            bitmapInfo: Image<UInt8>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5 - CGFloat(xRange.lowerBound), y: 0.5 - CGFloat(yRange.lowerBound + height))
        }

        try body(context)
    }
}

extension ImageSlice where Pixel == UInt16 {
    public var cgImage: CGImage {
        return ImageSlice<UInt16>.generatedCGImage(
            slice: self,
            colorSpace: Image<UInt16>.colorSpace,
            bitmapInfo: Image<UInt16>.bitmapInfo,
            componentType: UInt16.self
        )
    }

    public func withCGImage<R>(_ body: (CGImage) throws -> R) rethrows -> R {
        return try ImageSlice<UInt16>.withGeneratedCGImage(
            slice: self,
            colorSpace: Image<UInt16>.colorSpace,
            bitmapInfo: Image<UInt16>.bitmapInfo,
            body: body,
            componentType: UInt16.self
        )
    }

    public mutating func withCGContext(coordinates: CGContextCoordinates = .natural, _ body: (CGContext) throws -> Void) rethrows {
        precondition(width >= 0)
        precondition(height >= 0)

        let data: UnsafeMutablePointer<UInt16> = &self.image.pixels + (yRange.lowerBound * self.image.width + xRange.lowerBound)
        let context  = CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: MemoryLayout<UInt16>.size * 8,
            bytesPerRow: MemoryLayout<UInt16>.size * self.image.width,
            space: Image<UInt16>.colorSpace,
            bitmapInfo: Image<UInt16>.bitmapInfo.rawValue
        )!
        switch coordinates {
        case .original:
            break
        case .natural:
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0.5 - CGFloat(xRange.lowerBound), y: 0.5 - CGFloat(yRange.lowerBound + height))
        }

        try body(context)
    }
}
#endif
