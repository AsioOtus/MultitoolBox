import Foundation

let dispatchFirst = DispatchFirst()
let dispatchOnce = DispatchOnce{ print("QWERTY") }
let dispatchSerial = DispatchSerial()






DispatchQueue.concurrentPerform(iterations: 100) { i in
//	dispatchSerial.perform {
//		DispatchWait.for(.seconds(1))
//		print(i)
//	}
	
	dispatchOnce.perform()
	
//	dispatchOnce.perform {
//		print(i)
//	}
}

