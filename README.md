
# Part 01 - Convert a callback function into an Async function using Continuation.

Callbacks can be effective but often lead to messy code. The introduction of async and await provides a streamlined and linear syntax for handling concurrent computations, resulting in cleaner and more readable code.

## Features
- Conversion of callback functions to async functions
- Improved code readability and cleanliness

### Sample Code
```swift

private func delayAfter(delay: Int, completation: @escaping ((Int) -> Void)) {
    let dispatchAfter = DispatchTimeInterval.seconds(delay)
    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
        completation(delay)
    }
}

private func delayAfterAsync(delay: Int) async -> Int {
    return await withCheckedContinuation({ continuation in
        delayAfter(delay: delay) { delay in
            continuation.resume(returning: delay)
        }
    })
}
```

Please check the Code [Here](https://github.com/oviebd/Swift_Concurrency/blob/main/CallbackToAsync.playground/Contents.swift)

Check the detailed article from [Medium](https://pages.github.com/](https://habibur-rahman-ovie.medium.com/swift-concurrency-convert-a-callback-function-into-an-async-function-using-continuation-f412b7799d52)https://habibur-rahman-ovie.medium.com/swift-concurrency-convert-a-callback-function-into-an-async-function-using-continuation-f412b7799d52).



# Part 02 - Async let: Call multiple tasks asynchronously.

This part delves into the technique of invoking multiple tasks asynchronously and provides a performance comparison.

## Highlights
- Asynchronous task execution
- Performance evaluation and comparison

### Sample Code
```swift
private func SynchronousTask() async throws {
    let firstDelay = try await delayAfter(delay: 4) //1
    print("First Delay \(firstDelay)")  //2
    let secondDelay = try await delayAfter(delay: 2) //3
    print("Second Delay \(secondDelay)") //4
}

private func ASynchronousTask() async throws{
    async let firstDelay = delayAfter(delay: 4) //1
    async let secondDelay = delayAfter(delay: 2) //2
 
    print("First Delay\(try await firstDelay)") //3
    print("Second Delay\(try await secondDelay)") //4
}
```

Please check the Code [Here](https://github.com/oviebd/Swift_Concurrency/blob/main/AsynchronousTasks_Async-Let.playground/Contents.swift)

Check the detailed article from [Medium](https://medium.com/@habibur-rahman-ovie/swift-concurrency-part-02-async-let-call-multiple-tasks-asynchronously-e597e1a6bdf3).

# Part 03 - Task cancellation and call tasks in a loop.

This article focuses on the execution of a list of tasks. The article will also delve into the significance of task cancellation, particularly when a task encounters an error.

## Highlights
- Task Execution Loop
- Task Cancellation

### Sample Code
```swift
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
```

Please check the Code [Here](https://github.com/oviebd/Swift_Concurrency/blob/main/TaskGroup.playground/Contents.swift)

Check the detailed article from [Medium](https://habibur-rahman-ovie.medium.com/swift-concurrency-part-03-task-cancellation-and-call-tasks-in-a-loop-60ebaaec14bf).


# Part 04 - Task cancellation and call tasks in a loop.

In this installment, our focus shifts to the parallel execution of tasks, accomplished efficiently through the use of Task Groups.


## Highlights
- Exploring Parallel Execution
- Task Efficiency with Task Groups

### Sample Code
```swift
func getProcessingTime(students: [Student]) async throws {
   
    var processingTimeList: [Int: Int] = [:]

    await withTaskGroup(of: Void.self, body: { group in
        for student in students {
            group.addTask {
                do {
                    let processingTime = try await delayAfter(delay: student.processingTime)
                    print("processing Time \(processingTime)  id \(student.id)")
                     processingTimeList[student.id] = processingTime
                } catch {
                    print("error   id \(student.id)")
                }
            }
        }
    })
}
```

Please check the Code [Here](https://github.com/oviebd/Swift_Concurrency/blob/main/TaskGroup.playground/Contents.swift)

Check the detailed article from [Medium](https://medium.com/@habibur-rahman-ovie/swift-concurrency-part-04-group-task-f573a5827527).



