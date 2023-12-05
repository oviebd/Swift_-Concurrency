import UIKit

enum CustomError: Error {
    case delayError
}

private func delayAfter(delay: Int) async throws -> Int {
    
    if delay % 2 == 0 {
        throw CustomError.delayError
    }
    try await Task.sleep(
        until: .now + .seconds(delay),
        clock: .suspending
    )

    return delay
}



var delays = [1,2,3,4]

func performTaskLoops() async throws {
    for delay in delays {
        let d = try await delayAfter(delay: delay)
        print(d)
    }
}

func performTaskLoopsInCancelable() async throws {
    
    var cancelledTaskDelays = [Int]()
   
    for delay in delays {
        do {
            try Task.checkCancellation()
            let d = try await delayAfter(delay: delay)
            print(d)
        }catch{
            cancelledTaskDelays.append(delay)
        }
    }
    
    print("Cancelled delays \(cancelledTaskDelays)")
}

Task{
    
    let startTime = DispatchTime.now()
    
   // try await performTaskLoops()
    try await performTaskLoopsInCancelable()
    
    let endTime = DispatchTime.now()
    let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
    print("ElapsedTime \(elapsedTime)")
}
