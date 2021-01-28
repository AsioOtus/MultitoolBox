import Foundation

extension GenericPassword {
	struct Coder {
		static func encode <T: Encodable> (_ object: T) throws -> Data {
			do {
				let data = try JSONEncoder().encode(object)
				return data
			} catch {
				throw GenericPasswordError.Category.Coding.encodingFailed(error)
			}
		}
		
		static func decode <T: Decodable> (_ data: Data, _ type: T.Type) throws -> T {
			do {
				let object = try JSONDecoder().decode(type, from: data)
				return object
			} catch {
				throw GenericPasswordError.Category.Coding.decodingFailed(error)
			}
		}
	}
}
