import UIKit

// Custom error
enum CustomError: Error {
    case delayError
}

//Callback function.
private func delayAfter(delay: Int, completation: @escaping ((Int) -> Void)) {
    
    let dispatchAfter = DispatchTimeInterval.seconds(delay)
    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
        completation(delay)
    }
}

func callAsync() async {
    let delayAfter = await delayAfterAsync(delay: 2)
    print("01 Returning After \(delayAfter)")
}

func callAsyncThrowable() async throws {
    
    do {
        let delay = try await delayAfterAsyncThrowable(delay: 2)
        print("02 Returning After \(delay)")
    }catch{
        print("02 error - \(error)")
    }
    
}

private func delayAfterAsync(delay: Int) async -> Int {
    return await withCheckedContinuation({ continuation in
        delayAfter(delay: delay) { delay in
            continuation.resume(returning: delay)
        }
    })
}

private func delayAfterAsyncThrowable(delay: Int) async throws -> Int {
    return try await withCheckedThrowingContinuation({ continuation in
        delayAfter(delay: delay) { _ in
            if delay % 2 == 0 {
                continuation.resume(returning: delay)
            } else {
                continuation.resume(throwing: CustomError.delayError)
            }
        }
    })
}

Task { await callAsync() }
Task { try await callAsyncThrowable() }



