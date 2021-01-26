import Foundation

extension Item {
	public struct Coder {
		static func encode <T: Encodable> (_ object: T) throws -> String {
			do {
				let jsonData = try JSONEncoder().encode(object)
				guard let jsonString = String(data: jsonData, encoding: .utf8) else { throw Error.codingError(.jsonDataDecodingFailed(jsonData.base64EncodedString())) }
				return jsonString
			} catch let error as Error {
				throw error
			} catch {
				throw Error.codingError(.encodingFailed(error))
			}
		}
		
		static func decode <T: Decodable> (_ jsonString: String, _ type: T.Type) throws -> T {
			do {
				guard let jsonData = jsonString.data(using: .utf8) else { throw Error.codingError(.jsonStringEncodingFailed(jsonString)) }
				let object = try JSONDecoder().decode(type, from: jsonData)
				return object
			} catch let error as Error {
				throw error
			} catch {
				throw Error.codingError(.decodingFailed(error))
			}
		}
	}
}
