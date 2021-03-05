import Foundation



public extension Data {
	init? (hex: String) {
		guard !hex.isHex else { return nil }
				
		let bytesStrings = hex.divide(fromEndBy: 2)
		var bytes = [UInt8]()
		
		for byteString in bytesStrings {
			guard let byte = UInt8(byteString, radix: 16) else { return nil }
			bytes.append(byte)
		}
		
		self.init(bytes)
	}
}



public extension Data {
	var array: [UInt8] {
		let array = Array(self)
		return array
	}
}



public extension Data {
	func padded (atStartTo size: Int, paddingByte: UInt8 = 0x00) -> Data {
		let paddedData = createPadData(size, paddingByte) + self
		return paddedData
	}
	
	func padded (atEndTo size: Int, paddingByte: UInt8 = 0x00) -> Data {
		let paddedData = self + createPadData(size, paddingByte)
		return paddedData
	}
	
	private func createPadData (_ size: Int, _ paddingByte: UInt8) -> Data {
		let paddingSize = size - count
		return paddingSize > 0 ? Data(Array(repeating: paddingByte, count: paddingSize)) : Data()
	}
}



public extension Data {
	func split (blockSize: Int) -> [Data] {
		var resultChunks = [Data]()
		
		var startIndex = 0
		var endIndex = blockSize
		
		while endIndex <= count {
			let chunk = Data(self[startIndex..<endIndex])
			resultChunks.append(chunk)
			
			startIndex += blockSize
			endIndex += blockSize
		}
		
		if startIndex < count {
			resultChunks.append(Data(self[startIndex...]))
		}
		
		return resultChunks
	}
}



public extension Data {
	var bin: String {
		return map { String(format: "%02b", $0) }.joined(separator: " ")
	}
	
	var oct: String {
		return map { String(format: "%02dx", $0) }.joined(separator: " ")
	}
	
	var dec: String {
		return map { String(format: "%02o", $0) }.joined(separator: " ")
	}
	
	var hex: String {
		return map { String(format: "%02hx", $0) }.joined(separator: " ")
	}
	
	
	
	var plainBin: String {
		return map { String(format: "%02b", $0) }.joined()
	}
	
	var plainOct: String {
		return map { String(format: "%02dx", $0) }.joined()
	}
	
	var plainDec: String {
		return map { String(format: "%02o", $0) }.joined()
	}
	
	var plainHex: String {
		return map { String(format: "%02hx", $0) }.joined()
	}
}
