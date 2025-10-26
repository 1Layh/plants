//
//  PlantReminder.swift
//  plant
//
//  Created by Layan on 04/05/1447 AH.
//


import SwiftUI

// ✅ تعريف Struct PlantReminder
struct PlantReminder: Identifiable {
    let id = UUID()
    let name: String
    let details: String
    let locationIcon: String
    var isCompleted: Bool = false
    let room: String
    let lightDetails: String
    let waterAmount: String
}

// ✅ الواجهة الرئيسية
struct TodayReminderView: View {
    @State private var isShowingAddPlantSheet = false
    @State private var todayReminders: [PlantReminder] = [
        PlantReminder(name: "Monstera", details: "Water at 09:00 AM", locationIcon: "drop.fill", isCompleted: false, room: "Kitchen", lightDetails: "Full sun", waterAmount: "20–50 ml"),
        PlantReminder(name: "Pothos", details: "Fertilize at 3:00 PM", locationIcon: "drop.fill", isCompleted: true, room: "Bedroom", lightDetails: "Full sun", waterAmount: "20–50 ml"),
        PlantReminder(name: "Orchid", details: "Mist leaves now", locationIcon: "drop.fill", isCompleted: true, room: "Living Room", lightDetails: "Full sun", waterAmount: "20–50 ml"),
        PlantReminder(name: "Spider", details: "Water now", locationIcon: "drop.fill", isCompleted: true, room: "Kitchen", lightDetails: "Full sun", waterAmount: "20–50 ml")
    ]

    private func binding(for reminder: PlantReminder) -> Binding<PlantReminder> {
        guard let index = todayReminders.firstIndex(where: { $0.id == reminder.id }) else {
            fatalError("Can't find reminder in array")
        }
        return $todayReminders[index]
    }

    var totalReminders: Int { todayReminders.count }
    var completedReminders: Int { todayReminders.filter { $0.isCompleted }.count }
    var progress: Double { totalReminders > 0 ? Double(completedReminders) / Double(totalReminders) : 0 }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            List {
                headerView
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.black)

                ForEach(todayReminders) { reminder in
                    ReminderRow(reminder: self.binding(for: reminder))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.black)
                }
            }
            .listStyle(.plain)
            .padding(.top, -30)

            // ✅ شاشة Set Reminder تظهر من الأعلى
            if isShowingAddPlantSheet {
                VStack(spacing: 20) {
                    HStack {
                        Text("Set Reminder")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isShowingAddPlantSheet = false
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color.green)
                        }
                    }

                    Group {
                        ReminderField(title: "Plant Name", value: "Pothos", icon: "leaf.fill")
                        ReminderField(title: "Room", value: "Bedroom", icon: "bed.double.fill")
                        ReminderField(title: "Light", value: "Full sun", icon: "sun.max.fill")
                        ReminderField(title: "Watering Days", value: "Every day", icon: "calendar")
                        ReminderField(title: "Water", value: "20–50 ml", icon: "drop.fill")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
                .transition(.move(edge: .top))
                .animation(.spring(), value: isShowingAddPlantSheet)
            }

            // ✅ زر الإضافة العائم
            Button(action: {
                withAnimation {
                    isShowingAddPlantSheet = true
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 55, height: 55)
                    .foregroundColor(.white)
                    .background(
                        Circle().fill(.ultraThinMaterial)
                            .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: 3)
                    )
                    .overlay(
                        Circle().stroke(.white.opacity(0.3), lineWidth: 1.5)
                    )
            }
            .clipShape(Circle())
            .padding(.trailing, 25)
            .padding(.bottom, 35)
        }
        .preferredColorScheme(.dark)
    }

    var headerView: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("My Plants 🌱")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 20)

            HStack {
                Text(completedReminders == totalReminders ?
                     "All tasks complete! ✨" :
                     "\(completedReminders) of your plants feel loved today! 🪴")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3).frame(width: geometry.size.width, height: 6).foregroundColor(Color(white: 0.15))
                    RoundedRectangle(cornerRadius: 3).frame(width: geometry.size.width * CGFloat(progress), height: 6).foregroundColor(Color.green)
                }
            }
            .frame(height: 6).padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
}

// ✅ صف النبتة
struct ReminderRow: View {
    @Binding var reminder: PlantReminder

    var foregroundColor: Color { reminder.isCompleted ? .gray : .white }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable().frame(width: 25, height: 25)
                .foregroundColor(reminder.isCompleted ? Color.green : .gray)
                .onTapGesture { withAnimation(.spring()) { reminder.isCompleted.toggle() } }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 10)).foregroundColor(.gray)
                    Text("in \(reminder.room)")
                        .font(.caption).foregroundColor(.gray)
                }

                Text(reminder.name).font(.headline).foregroundColor(foregroundColor)

                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "sun.max.fill").font(.system(size: 10)).foregroundColor(.gray)
                        Text(reminder.lightDetails).font(.caption).foregroundColor(.gray)
                    }

                    HStack(spacing: 5) {
                        Image(systemName: "drop.fill").font(.system(size: 10)).foregroundColor(.gray)
                        Text(reminder.waterAmount).font(.caption).foregroundColor(.gray)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// ✅ مكون حقل التذكير
struct ReminderField: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text("\(title) | \(value)")
                .foregroundColor(.white)
                .font(.subheadline)
            Spacer()
        }
    }
}

// ✅ المعاينة
#Preview {
    TodayReminderView()
}
