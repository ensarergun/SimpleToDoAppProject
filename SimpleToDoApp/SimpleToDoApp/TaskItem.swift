import Foundation
import SwiftData

@Model
class TaskItem {
    var title: String
    var isDone: Bool
    var date: Date

    init(title: String, isDone: Bool = false, date: Date) {
        self.title = title
        self.isDone = isDone
        self.date = date
    }
}
