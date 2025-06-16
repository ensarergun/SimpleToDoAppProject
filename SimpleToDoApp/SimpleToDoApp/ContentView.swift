import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [TaskItem]
    
    @State private var newTask: String = ""
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                HStack {
                    TextField("Yeni görev gir...", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 36)

                    Button(action: addTask) {
                        Image(systemName: "plus")
                            .padding(.horizontal, 8)
                    }
                }
                .padding(.horizontal)

                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Tamamlanma: %\(Int(completionRate() * 100))")
                        .font(.caption)
                        .padding(.horizontal)

                    ProgressView(value: completionRate())
                        .tint(.green)
                        .frame(height: 8)
                        .clipShape(Capsule())

                }


                List {
                    ForEach(tasks) { task in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    toggleDone(task)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(task.title)
                                    .strikethrough(task.isDone)
                                    .font(.body)

                                Text(formattedDate(task.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Görevler")
        }
    }

    func addTask() {
        guard !newTask.isEmpty else { return }
        let newItem = TaskItem(title: newTask, isDone: false, date: selectedDate)
        context.insert(newItem)
        scheduleNotification(title: "Yeni görev eklendi")
        newTask = ""
        selectedDate = Date()
    }


    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            context.delete(task)
        }
    }

    func toggleDone(_ task: TaskItem) {
        task.isDone.toggle()
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func scheduleNotification(title: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Yapılacak görevi unutma!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    
    func completionRate() -> Double {
        guard !tasks.isEmpty else { return 0 }
        let doneCount = tasks.filter { $0.isDone }.count
        return Double(doneCount) / Double(tasks.count)
    }


}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self)
}
