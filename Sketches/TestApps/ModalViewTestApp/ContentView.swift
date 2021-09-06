import SwiftUI





class AppState: ObservableObject {
	static let standard = AppState()
	
	@Published var global = "123"
}





struct ContentView: View {
	var body: some View {
		ViewA(vma: .init(AppState.standard))
			.environmentObject(AppState.standard)
			.background(Color(hue: .random(in: 0...0.99), saturation: .random(in: 0...0.99), brightness: 0.5))
			.padding(4)
	}
}





class ViewModelA: ObservableObject {
	@ObservedObject var appState: AppState
	
	init (_ appState: AppState) { self.appState = appState }
}

struct ViewA: View {
	@EnvironmentObject var appState: AppState
	@ObservedObject var vma: ViewModelA
	
	var body: some View {
		VStack {
			Button("Action A") {
				vma.appState.global = "rty"
			}
			Text(vma.appState.global)
			ViewB(vmb: .init(vma.appState))
				.background(Color(hue: .random(in: 0...0.99), saturation: .random(in: 0...0.99), brightness: 0.5))
				.padding(4)
		}
	}
}





class ViewModelB: ObservableObject {
	@ObservedObject var appState: AppState
	
	init (_ appState: AppState) { self.appState = appState }
}

struct ViewB: View {
//	@EnvironmentObject var appState: AppState
	@ObservedObject var vmb: ViewModelB
	
	var body: some View {
		VStack {
			Button("Action B") {
				vmb.appState.global = "zxc"
			}
			Text(vmb.appState.global)
			ViewC(vmc: .init(vmb.appState))
				.background(Color(hue: .random(in: 0...0.99), saturation: .random(in: 0...0.99), brightness: 0.5))
				.padding(4)
		}
	}
}





class ViewModelC: ObservableObject {
	@ObservedObject var appState: AppState
	
	init (_ appState: AppState) { self.appState = appState }
}

struct ViewC: View {
	@ObservedObject var vmc: ViewModelC
	
	var body: some View {
		VStack{
			Text("qwe")
			Text(vmc.appState.global)
		}
	}
}
