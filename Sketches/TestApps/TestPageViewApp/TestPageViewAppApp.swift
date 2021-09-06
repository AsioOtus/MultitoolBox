import SwiftUI

@main
struct TestPageViewAppApp: App {
    var body: some Scene {
        WindowGroup {
			EndlessTabView()
        }
    }
}

class A: ObservableObject, Hashable {
	static func == (lhs: A, rhs: A) -> Bool { false }
	
	@Published var a = A1()
	@Published var b = [B]()
}
extension A {
	class A1: Hashable {
		static func == (lhs: A.A1, rhs: A.A1) -> Bool {
			false
		}		
	}
}


class B: ObservableObject, Hashable {
	@Published var c = [C]()
}

class C: ObservableObject, Hashable {
	let string = String.randomString(length: 10)
}



class AViewModel: ObservableObject {
	var b: [B]
	
	init (_ b: [B]) { self.b = b }
}

class BViewModel: ObservableObject {
	
}

class CViewModel: ObservableObject {
	
}





struct AView: View {
	@EnvironmentObject var avm: AViewModel
	
	var body: some View {
		VStack {
			ForEach(avm.b, id: \.self) { _ in
				BView()
					.environmentObject(BViewModel())
				
			}
		}
	}
}

struct BView: View {
	@EnvironmentObject var bvm: BViewModel
	
	var body: some View {
		EmptyView()
	}
}

struct CView: View {
	var body: some View {
		
	}
}



extension String {
static func randomString(length: Int) -> String {
	let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	return String((0..<length).map{ _ in letters.randomElement()! })
}
}
