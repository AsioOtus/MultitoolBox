import Foundation

extension String {
	public enum Side {
		case start
		case end
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

public extension Data {
	var bin: String {
		map { String($0, radix: 2).padded(atStartTo: 8, with: "0") }.joined(separator: " ")
	}
	
	var oct: String {
		map { String($0, radix: 8).padded(atStartTo: 3, with: "0") }.joined(separator: " ")
	}
	
	var dec: String {
		map { String($0, radix: 10) }.joined(separator: " ")
	}
	
	var hex: String {
		map { String($0, radix: 16).padded(atStartTo: 2, with: "0") }.joined(separator: " ")
	}
	
	
	
	var plainBin: String {
		map { String($0, radix: 2) }.joined()
	}
	
	var plainOct: String {
		map { String($0, radix: 8) }.joined()
	}
	
	var plainDec: String {
		map { String($0, radix: 10) }.joined()
	}
	
	var plainHex: String {
		map { String($0, radix: 16) }.joined()
	}
	
	
	
	var prefixBin: String {
		map { String($0, radix: 2).padded(atStartTo: 8, with: "0") }.map{ "0b\($0)" }.joined(separator: " ")
	}
	
	var prefixOct: String {
		map { String($0, radix: 8).padded(atStartTo: 3, with: "0") }.map{ "0o\($0)" }.joined(separator: " ")
	}
	
	var prefixDec: String {
		map { String($0, radix: 10) }.map{ "0d\($0)" }.joined(separator: " ")
	}
	
	var prefixHex: String {
		map { String($0, radix: 16).padded(atStartTo: 2, with: "0") }.map{ "0x\($0)" }.joined(separator: " ")
	}
}

//print(123456789.data.hex)
//
//
////let a = "abc".data(using: .windowsCP1251)
////let b = "abc".data(using: .windowsCP1252)
//
//let s = Data([0xD0])
//
//let aa = String(data: s, encoding: .windowsCP1251)!
//let bb = String(data: s, encoding: .windowsCP1252)!
//
//print(aa)
//print(bb)
//
//let cc = aa.data(using: .utf8)!
//let dd = bb.data(using: .utf8)!
//
//print(cc.hex)
//print(dd.hex)
//
//let aaa = String(data: cc, encoding: .utf8)!
//let bbb = String(data: dd, encoding: .utf8)!
//
//print(aaa)
//print(bbb)

let win1251Data = "Найменування проекту".data(using: .windowsCP1251)!
//let win1252Data = "Найменування проекту".data(using: .windowsCP1252)!
let win1251String = String(data: win1251Data, encoding: .windowsCP1251)!
let win1252String = String(data: win1251Data, encoding: .windowsCP1252)!

let utfDataA = win1251String.data(using: .utf8)!
let utfDataB = win1252String.data(using: .utf8)!

String(bytes: [1, 2, 3], encoding: .ascii)

let ab = String(data: utfDataA, encoding: .windowsCP1251)!
let qwer = String(data: utfDataB, encoding: .isoLatin1)!
//let ac = String(data: utfDataB, encoding: .windowsCP1252)!
//let ad = String(data: utfDataA, encoding: .windowsCP1252)!

print(ab)
//print(ac)
//print(ad)
print(qwer)

print(win1251String)
print(win1252String)



print(utfDataA.hex)
print(utfDataB.hex)

//print()
//
//print(Data([13]).bin)
//print(Data([0xd]).bin)
//
//print()
//
//print(String(format: "%02x", UInt8(13)))
//print(String(format: "%02x", Int8(13)))
//
//print(String(format: "%02x", UInt(141)))
//print(String(format: "%02x", Int(141)))
//
//print(String(format: "%02d", Data([141]).first!))
//print(String(format: "%02d", Data([141]).first!))
//
//print(String(format: "%02d", Data([141]).first!))
//print(String(format: "%02d", Data([141]).first!))
//
//
//func print (_ string: String, _ encoding: String.Encoding) {
//	let data = string.data(using: encoding)!
//	print(data.bin, data.dec, data.hex, data.map{ String(format: "%02d", $0) }.joined(separator: " "), separator: "    ")
//	print()
//}
//
//func print (_ data: Data, _ encoding: String.Encoding) {
//	print(String(data: data, encoding: encoding))
//}
////
//print("abc", .utf8)
////print("абв", .windowsCP1251)
////print("123", .utf8)
////
//////print("abc", .isoLatin1)
//////print("абв", .isoLatin1)
//////print("123", .isoLatin1)
////
////
////
//print("abc".data(using: .utf8)!.map{ String(format: "%02o", $0) }.joined(separator: " "))
//print(Data([141, 142, 143]).map{ String(format: "%02o", $0) }.joined(separator: " "))
////
//print(Data([97, 98, 99]), .utf8)
////print(Data([]), .utf8)
////print(Data([]), .utf8)
