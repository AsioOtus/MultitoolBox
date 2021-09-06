import SwiftUI
import Combine

class VMA: ObservableObject {
	var appState = app
	
	var cancellables = Set<AnyCancellable>()
	
	init () {
		appState.$b.sink { value in
			print("!!!")
		}.store(in: &cancellables)
	}
}

class AppState: ObservableObject {
	@Published var a: String = "123"
	@Published var b: String = "abc"
}

var app = AppState()

struct ContentView: View {
	@ObservedObject var vm = VMA()
	@State var aaa = "cvsverwverv"
	
    var body: some View {
		VStack {
//			Text(vm.a)
			
			Button("Action") {
				app.a = "55555"
				app.b = "4444"
			}
		}
    }
}
