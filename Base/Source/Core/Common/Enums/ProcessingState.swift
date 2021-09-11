public enum ProcessingState <Initial, Processing, Completed> {
	case inital(Initial)
	case processing(Processing)
	case completed(Completed)
	case failed(Error)
	
	public var stateName: String {
		switch self {
		case .inital:
			return "inital"
			
		case .processing:
			return "processing"
			
		case .completed:
			return "completed"
			
		case .failed:
			return "failed"
		}
	}
}
