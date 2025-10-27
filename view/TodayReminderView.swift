//
//  TodayReminderView.swift
//  plant
//
//  Created by Layan on 30/04/1447 AH.
//
import SwiftUI
import UserNotifications

struct TodayReminderView: View {
    @ObservedObject var viewModel: TodayReminderViewModel

    @State private var isShowingAddPlantSheet = false
    @State private var isShowingEditSheet = false
    @State private var selectedReminderForEdit: PlantReminder? = nil

    @State private var selectedFilter: String = ""
    @State private var plusPressed = false
    @State private var showAllDone = false

    private func binding(for reminder: PlantReminder) -> Binding<PlantReminder> {
        Binding(
            get: {
                viewModel.reminders.first(where: { $0.id == reminder.id }) ?? reminder
            },
            set: { updated in
                viewModel.update(updated)
                evaluateAllDone()
            }
        )
    }

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            Color.black.ignoresSafeArea()

            if showAllDone {
                // حالة "الكل منتهٍ": نعرض AllDone داخل الصفحة
                VStack {
                    AllDoneHeader()
                    Spacer()

                    ZStack {
                        Image("Image 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 280)

                        Image("all_done_plant")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .offset(y: -20)
                    }
                    .padding(.bottom, 20)

                    Text("All Done! 🎉")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text("All Reminders Completed")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()
                }

                // زر + الدائري
                addButton
                    .padding(.trailing, 25)
                    .padding(.bottom, 35)

            } else {
                // الحالة العادية: قائمة بالتذكيرات + زر +
                List {
                    headerView
                        .listRowSeparatorTint(.clear)
                        .listRowBackground(Color.black)

                    filterBar
                        .listRowSeparatorTint(.clear)
                        .listRowBackground(Color.black)

                    ForEach(viewModel.reminders) { reminder in
                        ReminderRow(reminder: self.binding(for: reminder)) {
                            viewModel.toggleCompleted(id: reminder.id)
                            evaluateAllDone()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedReminderForEdit = reminder
                            isShowingEditSheet = true
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.delete(id: reminder.id)
                                evaluateAllDone()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowSeparatorTint(.clear)
                        .listRowBackground(Color.black)
                    }
                }
                .listStyle(.plain)
                .background(Color.black)
                .padding(.top, -30)
                .ignoresSafeArea(.keyboard, edges: .bottom)

                addButton
                    .padding(.trailing, 25)
                    .padding(.bottom, 35)
            }
        }
        .preferredColorScheme(.dark)

        // شيت إضافة/تعديل
        .sheet(isPresented: $isShowingAddPlantSheet) {
            SetReminderView(
                reminderToEdit: nil,
                onSave: { newPlant in
                    viewModel.add(newPlant)
                    evaluateAllDone()
                    // جدولة إشعار تجريبي بعد 5 ثواني ليظهر مثل الصورة
                    scheduleWaterReminderTest(after: 5)
                },
                onUpdate: nil,
                onDelete: nil
            )
        }
        .sheet(isPresented: $isShowingEditSheet, onDismiss: {
            selectedReminderForEdit = nil
        }) {
            if let editing = selectedReminderForEdit {
                SetReminderView(
                    reminderToEdit: editing,
                    onSave: { _ in },
                    onUpdate: { updated in
                        viewModel.update(updated)
                        evaluateAllDone()
                    },
                    onDelete: { id in
                        viewModel.delete(id: id)
                        evaluateAllDone()
                    }
                )
            } else {
                Color.black.ignoresSafeArea()
            }
        }

        .onChange(of: viewModel.completedReminders) { _, _ in
            evaluateAllDone()
        }
        .onChange(of: viewModel.totalReminders) { _, _ in
            evaluateAllDone()
        }
        .onAppear {
            evaluateAllDone()
        }
    }

    // زر + الدائري (مستخرج كـ View لنعيد استخدامه في الحالتين)
    private var addButton: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                plusPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    plusPressed = false
                    isShowingAddPlantSheet = true
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("green1").opacity(0.95),
                                Color("green1").opacity(0.75)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.55), Color.white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color("green1").opacity(0.35), radius: 10, x: 0, y: 6)
                    .shadow(color: .black.opacity(0.6), radius: 20, x: 0, y: 10)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.22), .clear],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .scaleEffect(0.98)
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)

                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
            }
            .frame(width: 58, height: 58)
            .scaleEffect(plusPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: plusPressed)
            .accessibilityLabel("Add Plant Reminder")
            .accessibilityAddTraits(.isButton)
        }
    }

    private func scheduleWaterReminderTest(after seconds: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let’s water your plant"
        content.sound = .default

        // مرفق اختياري لصورة صغيرة إن وُجدت داخل الـ Bundle باسم image3.png
        if let url = Bundle.main.url(forResource: "image3", withExtension: "png"),
           let attachment = try? UNNotificationAttachment(identifier: "thumb", url: url, options: nil) {
            content.attachments = [attachment]
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    private func evaluateAllDone() {
        let shouldShow = viewModel.totalReminders > 0 && viewModel.completedReminders == viewModel.totalReminders
        if shouldShow != showAllDone {
            showAllDone = shouldShow
        }
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
                Text(viewModel.totalReminders > 0 && viewModel.completedReminders == viewModel.totalReminders ?
                     "All tasks complete! ✨" :
                     "\(viewModel.completedReminders) of your plants feel loved today! 🪴")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: geometry.size.width, height: 6)
                        .foregroundColor(Color(white: 0.15))
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: geometry.size.width * CGFloat(viewModel.progress), height: 6)
                        .foregroundColor(Color("green1"))
                }
            }
            .frame(height: 6)
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }

    var filterBar: some View {
        HStack(spacing: 10) {
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 15)
    }
}

private struct AllDoneHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Plants 🌱")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 60)

            Divider()
                .background(Color.white)
                .padding(.horizontal)
        }
    }
}

struct ReminderRow: View {
    @Binding var reminder: PlantReminder
    var onToggle: () -> Void

    var foregroundColor: Color { reminder.isCompleted ? .gray : .white }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(reminder.isCompleted ? Color("green1") : .gray)
                .onTapGesture {
                    withAnimation(.spring()) {
                        onToggle()
                    }
                }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Text("in \(reminder.room)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack {
                    Text(reminder.name)
                        .font(.headline)
                        .foregroundColor(foregroundColor)
                    Spacer()
                }

                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text(reminder.lightDetails)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    HStack(spacing: 5) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text(reminder.waterAmount)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TodayReminderView(viewModel: TodayReminderViewModel())
}
