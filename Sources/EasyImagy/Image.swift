public struct Image<Pixel> {
	public let width: Int
	public let height: Int
	public fileprivate(set) var pixels: [Pixel]
	
	public init(width: Int, height: Int, pixels: [Pixel]) {
		precondition(width >= 0, "`width` must be greater than or equal to 0: \(width)")
		precondition(height >= 0, "`height` must be greater than or equal to 0: \(height)")
		
		self.width = width
		self.height = height
		
		let count = width * height

		precondition(pixels.count >= count, "`pixels` must have more elements than `width` * `height`: \(count) < \(width) * \(height)")
		
		if pixels.count == count {
			self.pixels = pixels
		} else {
			self.pixels = [Pixel](pixels[0..<count])
		}
	}
}

extension Image { // Additional initializers
	public init(width: Int, height: Int, pixel: Pixel) {
		self.init(width: width, height: height, pixels: [Pixel](repeating: pixel, count: width * height))
	}
}

extension Image { // Initializers for ImageSlice
	public init(_ imageSlice: ImageSlice<Pixel>) {
		self.init(width: imageSlice.width, height: imageSlice.height, pixels: imageSlice.pixels)
	}
}

extension Image {
	public var count: Int {
		return width * height
	}
}

extension Image { // Subscripts (Index)
	fileprivate func isValidX(_ x: Int) -> Bool {
		return 0 <= x && x < width
	}
	
	fileprivate func isValidY(_ y: Int) -> Bool {
		return 0 <= y && y < height
	}
	
	fileprivate func _pixelIndex(x: Int, y: Int) -> Int {
		precondition(isValidX(x), "`x` is out of bounds: \(x)")
		precondition(isValidY(y), "`y` is out of bounds: \(y)")
		return y * width + x
	}
	
	internal func _safePixelIndex(x: Int, y: Int) -> Int {
		return _pixelIndex(x: clamp(x, lower: 0, upper: width - 1), y: clamp(y, lower: 0, upper: height - 1))
	}
	
	public func pixelIndex(x: Int, y: Int) -> Int? {
		guard isValidX(x) else { return nil }
		guard isValidY(y) else { return nil }
		return _pixelIndex(x: x, y: y)
	}
	
	public subscript(x: Int, y: Int) -> Pixel {
		get {
			return pixels[_pixelIndex(x: x, y: y)]
		}
		set {
			pixels[_pixelIndex(x: x, y: y)] = newValue
		}
	}
}

extension Image { // safe get
	public func pixelAt(x: Int, y: Int) -> Pixel? {
		guard let pixelIndex = self.pixelIndex(x: x, y: y) else { return nil }
		return pixels[pixelIndex]
	}
}

extension Image : Sequence {
	public func makeIterator() -> IndexingIterator<[Pixel]> {
		return pixels.makeIterator()
	}
}

public func ==<Pixel: Equatable>(lhs: Image<Pixel>, rhs: Image<Pixel>) -> Bool {
	if lhs.width != rhs.width || lhs.height != rhs.height {
		return false
	}
	
	for (pixel1, pixel2) in zip(lhs, rhs) {
		if pixel1 != pixel2 {
			return false
		}
	}
	
	return true
}

extension Image { // Higher-order methods
	public func map<T>(_ transform: (Pixel) -> T) -> Image<T> {
		return _map(transform)
	}
	
	internal func _map<T>(_ transform: (Pixel) -> T) -> Image<T> {
		return Image<T>(width: width, height: height, pixels: pixels.map(transform))
	}

	public func map<T>(_ transform: (_ x: Int, _ y: Int, _ pixel: Pixel) -> T) -> Image<T> {
		return _map(transform)
	}
	
	public func _map<T>(_ transform: (_ x: Int, _ y: Int, _ pixel: Pixel) -> T) -> Image<T> {
		var pixels: [T] = []
		pixels.reserveCapacity(count)
		var generator = makeIterator()
		for y in 0..<height {
			for x in 0..<width {
				pixels.append(transform(x, y, generator.next()!))
			}
		}
		return Image<T>(width: width, height: height, pixels: pixels)
	}

	public mutating func update(_ transform: (Pixel) -> Pixel) {
		for i in 0..<count {
			pixels[i] = transform(pixels[i])
		}
	}
}

extension Image { // Convolutions
    internal func _convoluted<W, Summable>(by kernel: Image<W>, toSummable: (Pixel) -> Summable, product: (Summable, W) -> Summable, zero: Summable, sum: (Summable, Summable) -> Summable, toOriginal: (Summable) -> Pixel) -> Image<Pixel> {
		precondition(kernel.width % 2 == 1, "The width of the `kernel` must be odd: \(kernel.width)")
		precondition(kernel.height % 2 == 1, "The height of the `kernel` must be odd: \(kernel.height)")
		
		let hw = kernel.width / 2  // halfWidth
		let hh = kernel.height / 2 // halfHeight
		
		var pixels: [Pixel] = []
		pixels.reserveCapacity(count)
		
		for y in 0..<height {
			for x in 0..<width {
				var weightedValues: [Summable] = []
				for fy in 0..<kernel.height {
					for fx in 0..<kernel.width {
						let dx = fx - hw
						let dy = fy - hh
                        let summablePixel = toSummable(self.pixels[_safePixelIndex(x: x + dx, y: y + dy)])
                        let weight = kernel[fx, fy]
						weightedValues.append(product(summablePixel, weight))
					}
				}
                pixels.append(toOriginal(weightedValues.reduce(zero) { sum($0, $1) }))
			}
		}
		
		return Image<Pixel>(width: width, height: height, pixels: pixels)
	}
}

extension Image { // Operations
	public func xReversed() -> Image<Pixel> {
		var pixels = [Pixel]()

		let maxX = width - 1
		for y in 0..<height {
			for x in 0..<width {
				pixels.append(self.pixels[pixelIndex(x: maxX - x, y: y)!])
			}
		}
		
		return Image(width: width, height: height, pixels: pixels)
	}
	
	public func yReversed() -> Image<Pixel> {
		var pixels = [Pixel]()
		
		let maxY = height - 1
		for y in 0..<height {
			for x in 0..<width {
				pixels.append(self.pixels[pixelIndex(x: x, y: maxY - y)!])
			}
		}
		
		return Image(width: width, height: height, pixels: pixels)
	}
	
	public func rotated() -> Image<Pixel> {
		return rotated(1)
	}
	
	public func rotated(_ times: Int) -> Image<Pixel> {
		switch times % 4 {
		case 0:
			return self
		case 1, -3:
			var pixels = [Pixel]()
			
			let maxX = height - 1
			for y in 0..<width {
				for x in 0..<height {
					pixels.append(self.pixels[pixelIndex(x: y, y: maxX - x)!])
				}
			}
			
			return Image(width: height, height: width, pixels: pixels)
		case 2, -2:
			var pixels = [Pixel]()
			
			let maxX = width - 1
			let maxY = height - 1
			for y in 0..<height {
				for x in 0..<width {
					pixels.append(self.pixels[pixelIndex(x: maxX - x, y: maxY - y)!])
				}
			}
			
			return Image(width: width, height: height, pixels: pixels)
		case 3, -1:
			var pixels = [Pixel]()
			
			let maxY = width - 1
			for y in 0..<width {
				for x in 0..<height {
					pixels.append(self.pixels[pixelIndex(x: maxY - y, y: x)!])
				}
			}
			
			return Image(width: height, height: width, pixels: pixels)
		default:
			fatalError("Never reaches here.")
		}
	}
}