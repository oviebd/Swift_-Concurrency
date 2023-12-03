import UIKit

private func delayAfter(delay: Int) async throws -> Int {
    try await Task.sleep(
        until: .now + .seconds(delay),
        clock: .suspending
    )

    return delay
}

private func SynchronousTask() async throws{
    let firstDelay = try await delayAfter(delay: 4)
    print("First Delay\(firstDelay)")
    let secondDelay = try await delayAfter(delay: 2)
    print("Second Delay\(secondDelay)")
}


private func ASynchronousTask() async throws{
   
    async let firstDelay = delayAfter(delay: 4)
    async let secondDelay = delayAfter(delay: 2)
    print("First Delay\(try await firstDelay)")
    print("Second Delay\(try await secondDelay)")
   
}

//private func loopAsync() async throws {
//    let ids = [1,2,3,4,5]
//    for id in ids {
//        let delay = try await delayAfter(delay: id)
//        print(delay)
//    }
//    
//}


Task {
    let startTime = DispatchTime.now()
  
   // try await loopAsync()
   // try await SynchronousTask()
    try await ASynchronousTask()
    
    let endTime = DispatchTime.now()
    let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
    print("ElapsedTime \(elapsedTime)")
}
