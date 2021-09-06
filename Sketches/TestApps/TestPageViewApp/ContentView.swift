import SwiftUI
import SwiftUIPager
import SwiftDate
import DequeModule

struct Period: Equatable {
	let startDate: DateInRegion
	let endDate: DateInRegion
	
	var string: String {
		startDate.toFormat("dd.MM.yyyy HH:mm") + " – " + endDate.toFormat("dd.MM.yyyy HH:mm")
	}
}

struct Day: Equatable {
	let date: DateInRegion
}

enum IntervalType: Int, CaseIterable, Codable, Equatable {
	case day
	case week
	case month
	
	func dateComponent (count: Int = 1) -> DateComponents {
		switch self {
		case .day: return count.days
		case .week:	return count.weeks
		case .month: return count.months
		}
	}
	
	var previous: DateRelatedType {
		switch self {
		case .day: return .yesterday
		case .week:	return .prevWeek
		case .month: return .prevMonth
		}
	}
	
	var next: DateRelatedType {
		switch self {
		case .day: return .tomorrow
		case .week:	return .nextWeek
		case .month: return .nextMonth
		}
	}
	
	var start: DateRelatedType {
		switch self {
		case .day: return .startOfDay
		case .week: return .startOfWeek
		case .month: return .startOfMonth
		}
	}
	
	var end: DateRelatedType {
		switch self {
		case .day: return .endOfDay
		case .week:	return .endOfWeek
		case .month: return .endOfMonth
		}
	}
}

struct TableView: View {
	@State var intervalType = IntervalType.month
	
	var body: some View {
		VStack {
			Picker (selection: $intervalType, label: Text("")) {
				ForEach(IntervalType.allCases, id: \.self) { intervalType in
					Text(String(describing: intervalType))
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			.labelsHidden()
			.padding()
			
//			EndlessPagerView(intervalType: $intervalType)
		}
	}
	
	func a () {
		
	}
}

class ViewModel: ObservableObject {
	static let treshold = 2
	static let bufferSize = 3
	
	static let currentDate = DateInRegion().dateAt(.startOfDay)
	
	init () {
		self.periods = {
			let startDate = (Self.currentDate - intervalType.dateComponent(count: Self.bufferSize)).dateAt(intervalType.start)
			let endDate = (Self.currentDate + intervalType.dateComponent(count: Self.bufferSize)).dateAt(intervalType.end)
			
			let dates = DateInRegion.enumerateDates(from: startDate, to: endDate, increment: intervalType.dateComponent())
			let periods = dates.map{ Period(startDate: $0, endDate: $0.dateAt(intervalType.end)) }
			
			return Deque(periods)
		}()
	}
	
	@Published var intervalType: IntervalType = .month {
		didSet {
			print("KEK")
			self.periods = {
				let startDate = (Self.currentDate - intervalType.dateComponent(count: Self.bufferSize)).dateAt(intervalType.start)
				let endDate = (Self.currentDate + intervalType.dateComponent(count: Self.bufferSize)).dateAt(intervalType.end)
				
				let dates = DateInRegion.enumerateDates(from: startDate, to: endDate, increment: intervalType.dateComponent())
				let periods = dates.map{ Period(startDate: $0, endDate: $0.dateAt(intervalType.end)) }
				
				return Deque(periods)
			}()
		}
	}
	
	@Published var periods: Deque<Period> = []
	
	@Published var page: Page = .withIndex(bufferSize)
}

struct EndlessPagerView: View {
	static let treshold = 2
	static let bufferSize = 3
	static let newItemsCount = 1
	
	static let currentDate = DateInRegion().dateAt(.startOfDay)
	
	@StateObject var vm = ViewModel()
	
	var body: some View {
		VStack {
			Picker (selection: $vm.intervalType, label: Text("")) {
				ForEach(IntervalType.allCases, id: \.self) { intervalType in
					Text(String(describing: intervalType).capitalized)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			.labelsHidden()
			.padding()
			
			Text(String(describing: vm.intervalType).capitalized)
			
			Pager(page: vm.page, data: vm.periods, id: \.startDate) { period in
				PeriodView(period: period)
			}
			.draggingAnimation(.steep)
			.onPageChanged { i in
				withAnimation {
					if i <= Self.treshold, let firstPeriod = vm.periods.first {
						vm.page.index += Self.newItemsCount
						
						let newPeriodStartDate = firstPeriod.startDate.dateAt(vm.intervalType.previous)
						let newPeriod = Period(startDate: newPeriodStartDate, endDate: newPeriodStartDate.dateAt(vm.intervalType.end))
						
						vm.periods.prepend(newPeriod)
						vm.periods.removeLast()
					} else if i >= vm.periods.count - Self.treshold, let lastPeriod = vm.periods.last {
						vm.page.index -= Self.newItemsCount
						
						let newPeriodStartDate = lastPeriod.startDate.dateAt(vm.intervalType.next)
						let newPeriod = Period(startDate: newPeriodStartDate, endDate: newPeriodStartDate.dateAt(vm.intervalType.end))
						
						vm.periods.append(newPeriod)
						vm.periods.removeFirst()
					}
				}
			}
		}
	}
}



struct PeriodView: View {
	let period: Period
	let days: [Day]
	
	init (period: Period) {
		self.period = period
		self.days = DateInRegion.enumerateDates(from: period.startDate, to: period.endDate, increment: 1.days).map{ Day(date: $0) }
	}
	
	var body: some View {
		VStack {
			Text(period.string)
				.background(Color.white)
			
			List {
				ForEach(days, id: \.date) { day in
					DayView(day: day)
				}
			}
		}
	}
}

struct DayView: View {
	let day: Day
	
	var body: some View {
		Text(day.date.toFormat("dd.MM.yyyy HH:mm"))
			.background(Color.white)
	}
}
