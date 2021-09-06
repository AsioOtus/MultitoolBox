import SwiftUI
import DequeModule

extension EndlessTabView {
	class ViewModel: ObservableObject {
		@Published var items = Deque(1...6)
		@Published var current = 3
	}
}

struct EndlessTabView: View {
	@StateObject var vm = ViewModel()
	
	var body: some View {
		TabView {
			ForEach(vm.items, id: \.self) { item in
				Text("Tab \(item)")
					.onAppear {
						if vm.items.last! - 1 == item {
							vm.items.append(vm.items.last! + 1)
						} else if vm.items.first! + 1 == item {
							vm.items.prepend(vm.items.first! - 1)
						}
					}
			}
		}
		.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
		
	}
}
