import Foundation

extension String {
	public enum Side {
		case start
		case end
	}
}

public extension String {
	static let controlCharacters = [
		"\n",
		"\t"
	]
	
	static let escapedControlCharacter = [
		"\n": "\\n",
		"\t": "\\t"
	]
	
	static let newLine = "\n"
}



public extension String {
	func `repeat` (_ count: Int) -> String {
		return String(repeating: self, count: count)
	}
}



public extension String {
	static let defaultPaddingCharacter: Character = " "
	
	func padded (atStartTo length: Int, character: Character = String.defaultPaddingCharacter) -> String {
		let paddedString = createPadString(length, character) + self
		return paddedString
	}
	
	func padded (atEndTo length: Int, character: Character = String.defaultPaddingCharacter) -> String {
		let paddedString = self + createPadString(length, character)
		return paddedString
	}
	
	private func createPadString (_ length: Int, _ character: Character) -> String {
		let padStringLength = length - count
		return padStringLength > 0 ? String(repeating: character, count: padStringLength) : ""
	}
}



public extension String {
	static let defaultPaddingFillString: String = " "

	func padded (atStartTo length: Int, with fillString: String = String.defaultPaddingFillString, cutPadFrom paddingCutSide: Side = .start) -> String {
		return createPadString(length, fillString, paddingCutSide) + self
	}

	func padded (atEndTo length: Int, with fillString: String = String.defaultPaddingFillString, cutPadFrom paddingCutSide: Side = .end) -> String {
		return self + createPadString(length, fillString, paddingCutSide)
	}

	private func createPadString (_ length: Int, _ fillString: String, _ paddingCutSide: Side) -> String {
		var resultPadString = ""

		guard count < length else { return resultPadString }

		let padLength = length - count
		let padString = createPadString(length, fillString)

		resultPadString = paddingCutSide == .start
			? String(padString.suffix(padLength))
			: String(padString.prefix(padLength))

		return resultPadString
	}

	private func createPadString (_ length: Int, _ fillString: String) -> String {
		var padString = ""

		guard count < length else { return padString }

		let padLength = length - count
		padString = fillString

		if padLength > fillString.count {
			while padString.count < padLength {
				padString.append(fillString)
			}
		}

		return padString
	}
}



public extension String {
	static let defaultGroupSeparator = " "

	func grouped (fromStartBy groupSize: Int, with separator: String = defaultGroupSeparator) -> String {
		return self.divide(fromStartBy: groupSize).joined(separator: separator)
	}

	func grouped (fromEndBy groupSize: Int, with separator: String = defaultGroupSeparator) -> String {
		return self.divide(fromEndBy: groupSize).joined(separator: separator)
	}
	
	func divide (fromStartBy groupSize: Int) -> [String] {
		return self.divide(by: groupSize)
	}
	
	func divide (fromEndBy groupSize: Int) -> [String] {
		return String(self.reversed()).divide(by: groupSize).map{ $0.reversed }.reversed()
	}
	
	private func divide (by groupSize: Int) -> [String] {
		guard groupSize > 0 else { return [self] }
		
		var i = 0
		var groupString = ""
		var resultArray = [String]()
		
		for character in self {
			if i == groupSize {
				resultArray += [groupString]
				
				groupString = ""
				i = 0
			}
			
			groupString += String(character)
			i += 1
		}
		
		if groupString != "" {
			resultArray += [groupString]
		}
		
		return resultArray
	}
}



public extension String {
	var removedFirst: String {
		guard self.count > 0 else { return self }
		
		var resultString = self
		resultString.removeFirst()
		return resultString
	}
	
	var removedLast: String {
		guard self.count > 0 else { return self }
		
		var resultString = self
		resultString.removeLast()
		return resultString
	}

	var reversed: String {
		return String(self.reversed())
	}
}



public extension String {
	subscript (safe offset: Int) -> Character? {
		guard let resultIndex = self.index(self.startIndex, offsetBy: offset, limitedBy: self.endIndex) else { return nil }
		return self[resultIndex]
	}
	
	func index (at offset: Int) -> String.Index? {
		return self.index(self.startIndex, offsetBy: offset, limitedBy: self.endIndex)
	}
	
	func offset (of index: String.Index) -> Int? {
		return distance(from: startIndex, to: index)
	}
	
	func offset (of substring: String) -> Int? {
		guard let substringIndex = self.range(of: substring)?.lowerBound else { return nil }
		return offset(of: substringIndex)
	}
}



public extension String {
	var escaped: String {
		var escapedString = self
		
		for controlCharacter in String.controlCharacters {
			guard let escapedControlCharacter = String.escapedControlCharacter[controlCharacter] else { continue }
			escapedString = escapedString.replacingOccurrences(of: "\n", with: escapedControlCharacter)
		}
		
		return escapedString
	}
}



public extension String {
	var base64Encoded: String {
		let encodedString = self.data(using: .utf8)!.base64EncodedString()
		return encodedString
	}
	
	var base64Decoded: String? {
		guard let stringData = Data(base64Encoded: self) else { return nil }
		let decodedString = String(data: stringData, encoding: .utf8)
		return decodedString
	}
	
	init? (base64 string: String) {
		guard let decodedString = string.base64Decoded else { return nil }
		self = decodedString
	}
	
	init? (toBase64 string: String) {
		self = string.base64Encoded
	}
}



public extension String {
	var isHex: Bool {
		let isHex = self.allSatisfy{ $0.isHexDigit }
		return isHex
	}
}
