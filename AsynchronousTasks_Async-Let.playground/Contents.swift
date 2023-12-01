import UIKit

private func delayAfter(delay: Int) async throws -> Int {
    try await Task.sleep(
        until: .now + .seconds(delay),
        clock: .suspending
    )

    return delay
}

private func SynchronousTask() async throws{
    let startTime = DispatchTime.now()
    
    let firstDelay = try await delayAfter(delay: 4)
    print("First Delay\(firstDelay)")
    let secondDelay = try await delayAfter(delay: 2)
    print("Second Delay\(secondDelay)")
    
    let endTime = DispatchTime.now()
    let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
    print("ElapsedTime \(elapsedTime)")
}


private func ASynchronousTask() async throws{
    let startTime = DispatchTime.now()
   
    async let firstDelay = delayAfter(delay: 4)
    async let secondDelay = delayAfter(delay: 2)
  
    print("Second Delay\(try await secondDelay)")
    print("First Delay\(try await firstDelay)")
    
    let endTime = DispatchTime.now()
    let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
    print("ElapsedTime \(elapsedTime)")
}


Task {
  //  try await SynchronousTask()
    try await ASynchronousTask()
}
