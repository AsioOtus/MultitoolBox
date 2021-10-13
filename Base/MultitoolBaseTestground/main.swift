import Foundation

print("123".padded(atStartTo: 10, with: "ABCDEFGH"))
print("123".padded(atEndTo: 10, with: "ABCDEFGH"))

print(Data([0x01, 0x02, 0x03]).padded(atStartTo: 10, with: Data([0x08, 0x09])).prefixedHex)

print(Data([0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0x10]).split(chunkSize: -1).map{ $0.hex })
