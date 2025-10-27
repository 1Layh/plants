import Foundation

final class TodayReminderViewModel: ObservableObject {
    @Published private(set) var reminders: [PlantReminder]

    init(initialReminders: [PlantReminder] = []) {
        self.reminders = initialReminders
    }

    // MARK: - Derived values
    var totalReminders: Int { reminders.count }
    var completedReminders: Int { reminders.filter { $0.isCompleted }.count }
    var progress: Double {
        totalReminders > 0 ? Double(completedReminders) / Double(totalReminders) : 0
    }

    // MARK: - CRUD
    func add(_ reminder: PlantReminder) {
        reminders.append(reminder)
    }

    func update(_ reminder: PlantReminder) {
        if let idx = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[idx] = reminder
        }
    }

    func delete(id: UUID) {
        if let idx = reminders.firstIndex(where: { $0.id == id }) {
            reminders.remove(at: idx)
        }
    }

    func toggleCompleted(id: UUID) {
        if let idx = reminders.firstIndex(where: { $0.id == id }) {
            reminders[idx].isCompleted.toggle()
        }
    }
}
