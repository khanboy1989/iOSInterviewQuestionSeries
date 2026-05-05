import Foundation

//struct Task {
//    var title: String
//    var isCompleted: Bool
//}
//
//
//var originalTask: Task = .init(title: "Buy Groceries", isCompleted: false) // This is hold in Stack Region of Memory
//var editableTask: Task = originalTask // This is the copy of original task
//
//// After this two variables are completely strangers. They dont share the same memory.
//
//editableTask.title = "Buy Fruits"
//editableTask.isCompleted = true
//
//print("Original Task: \(originalTask)")
//print("Editable Task: \(editableTask)")
//// Value Types - struct lives on Stack
//
//class TaskManager {
//    var tasks: [String] = []
//    func addTask(_ title: String) {
//        tasks.append(title)
//    }
//}
//
//let manager1 = TaskManager() // Now this one is written on heap
//let manager2 = manager1 // Now they are both pointing the same memory reference on HEAP
//
//manager1.addTask("Design System")
//
//print("manager1:", manager1.tasks.count)  // 1
//print("manager2:", manager2.tasks.count)  // 1 — same object!
//
//print("Manager1 Address: \(ObjectIdentifier(manager1))")
//print("Manager2 Address: \(ObjectIdentifier(manager2))")

//class TaskSession {
//    let id: String
//    init(id: String) {
//        self.id = id
//        print("\(id), created - RC: 1")
//    }
//    
//    deinit {
//        print("\(id), deallocated - RC: 0")
//    }
//}
//
//func runDemo() {
//    let s1 = TaskSession(id: "Session-A") // RC = 1
//    do {
//        let s2 = s1 // RC = 2
//        let s3 = s1 // RC = 3
//    } // s2, s3 go out of scope RC back 1
//} // s1 goes out of scope and RC = 0 and deinit fires
//
//runDemo() // When the run demo is returned and cleaned up the RC hits zero
//

// Example 4: ARC with deinit and Retain Cycle Fix
//class Task {
//    var title: String
//    var reminder: Reminder?
//    
//    init(_ t: String) {
//        self.title = t
//        print("Task is initialized")
//    }
//    
//    deinit {
//        print("Task Cancelled") // watch: never fires
//    }
//}
//
//class Reminder {
//    var message: String
//    //var task: Task? // strong ref back -> CYCLE
//    
//    var task: Task? // This line helps use to make the instance of task as nil and RC = 0
//    
//    init(_ m: String) {
//        self.message = m
//        print("Reminder is initialized")
//    }
//    
//    deinit {
//        print("Reminder dealloacted") // watch: never fires
//    }
//}
//
//var task: Task? = Task("Submit PR")
//var reminder: Reminder? = Reminder("Don't Forget")
//
//task?.reminder = reminder
//reminder?.task = task
//
//task = nil // RC stil 1 - Reminder holds task
//reminder = nil // RC still 1 - Task holds reminder
//

// Example 5: Mixed Types: Struct Containing a Class
//class Category {
//    var name: String
//    init(_ name: String) {
//        self.name = name
//    }
//}
//struct Task {
//    var title: String
//    var category: Category
//}
//
//let work = Category("Work")
//var task1 = Task(title: "Code Review", category: work)
//
//var task2 = task1 // struct copied = two stack slots
//
//task2.category.name = "Personal"
//
//print(task1.category.name) // Personal - this part kind of not expected
//print(task2.category.name) // Personal

// Above: If we want to true value semantics we need to convert the class to struct


// Example 6: Stack Variable Capture: When the Stack moves to the heap
func makeCounter() -> () -> Int {
    var count = 0 // looks like a stack variable
    
    /// Escaping closure -> promotes it to the heap
    return {
        count += 1
        return count
    }
}

let counter = makeCounter() // makeCounter's stack frame is gone
// but count lives on — it's on the heap

print((counter()))
print(counter())
print(counter()) // When it is triggered swift says okay I need to wrap this into heap-allocated box.

