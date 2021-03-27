import Foundation

protocol HTTPURLResponseStringConverter {
    func convert (_ httpUrlResponse: HTTPURLResponse, body: Data?) -> String
}
