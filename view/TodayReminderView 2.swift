//
//  TodayReminderView.swift
//  plant
//
//  Created by Layan on 30/04/1447 AH.
//
import SwiftUI

struct PlantReminder: Identifiable {
    let id = UUID()
    let name: String
    let details: String
    let locationIcon: String
    var isCompleted: Bool = false
    // تفاصيل إضافية لتظهر في الـ Row الجديدة
    let room: String = "Kitchen"
    let lightDetails: String = "Full sun"
    let waterAmount: String = "20-50 ml"
}

struct TodayReminderView: View {
    
    // ✅ متغير لتتبع حالة عرض Sheet الإضافة
    @State private var isShowingAddPlantSheet = false

    @State private var todayReminders: [PlantReminder] = []

    
    @State private var selectedFilter: String = ""
    
    // الدالة المساعدة لحل مشكلة Binding في ForEach
    private func binding(for reminder: PlantReminder) -> Binding<PlantReminder> {
        guard let index = todayReminders.firstIndex(where: { $0.id == reminder.id }) else {
            fatalError("Can't find reminder in array")
        }
        return $todayReminders[index]
    }
    
    // حسابات شريط التقدم
    var totalReminders: Int { todayReminders.count }
    var completedReminders: Int { todayReminders.filter { $0.isCompleted }.count }
    var progress: Double { totalReminders > 0 ? Double(completedReminders) / Double(totalReminders) : 0 }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.ignoresSafeArea()
            
            List {
                
                headerView
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.black)
                
                filterBar
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.black)
                
                // ✅ استخدام ForEach المصحح
                ForEach(todayReminders) { reminder in
                    ReminderRow(reminder: self.binding(for: reminder))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.black)
                }
            }
            .listStyle(.plain)
            .background(Color.black)
            .padding(.top, -30)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            
            // ✅ زر الإضافة العائم (Liquid Glass FAB)
            Button(action: {
                isShowingAddPlantSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 55, height: 55) // تحديد الحجم
                    .foregroundColor(.white)
                    // 1. المادة الزجاجية (Liquid Glass Effect)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial) // المظهر الزجاجي
                            .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: 3)
                    )
                    // 2. الحدود الزجاجية (Glass Border)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 1.5)
                    )
            }
            // ❌ تم حذف buttonStyle(.glassProminent) واستبدالها بالـ background/overlay أعلاه
            .clipShape(Circle())
            .padding(.trailing, 25)
            .padding(.bottom, 35)
        }
        .preferredColorScheme(.dark)
        // ✅ موديفاير Sheet لاستدعاء SetReminderView (تأكيد عمل الـ Sheet)
        .sheet(isPresented: $isShowingAddPlantSheet) {
             Text("SetReminderView Placeholder") // Placeholder مؤقت
        }
    }
    
    // الأجزاء المساعدة
    var headerView: some View {
        VStack(alignment: .leading, spacing: 5) {
            // ✅ توسيط العنوان الرئيسي
            HStack {
                Text("My Plants 🌱")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 20)
            
            // ✅ توسيط نص التقدم
            HStack {
                Text(completedReminders == totalReminders ?
                     "All tasks complete! ✨" :
                     "\(completedReminders) of your plants feel loved today! 🪴")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }

            // شريط التقدم (Progress Bar)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3).frame(width: geometry.size.width, height: 6).foregroundColor(Color(white: 0.15))
                    RoundedRectangle(cornerRadius: 3).frame(width: geometry.size.width * CGFloat(progress), height: 6).foregroundColor(Color("green1"))
                }
            }
            .frame(height: 6).padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    var filterBar: some View {
        // ❌ شريط تصفية فارغ
        HStack(spacing: 10) {
            Spacer()
        }
        .padding(.horizontal).padding(.bottom, 15)
    }
}

// Struct للصف الواحد (Row)
struct ReminderRow: View {
    @Binding var reminder: PlantReminder
    
    var foregroundColor: Color { reminder.isCompleted ? .gray : .white }
    
    var body: some View {
        HStack(spacing: 15) {
            
            // 1. زر الدائرة (Checkmark)
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable().frame(width: 25, height: 25)
                .foregroundColor(reminder.isCompleted ? Color("green1") : .gray)
                .onTapGesture { withAnimation(.spring()) { reminder.isCompleted.toggle() } }

            // 2. المحتوى الرئيسي (الاسم والتفاصيل)
            VStack(alignment: .leading, spacing: 5) {
                
                // تفاصيل الموقع (in Kitchen)
                HStack(spacing: 5) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 10)).foregroundColor(.gray)
                    Text("in \(reminder.room)")
                        .font(.caption).foregroundColor(.gray)
                }
                
                // اسم النبتة
                Text(reminder.name).font(.headline).foregroundColor(foregroundColor)
                
                // التفاصيل الإضافية (Light & Water)
                HStack(spacing: 15) {
                    
                    // Light التفاصيل
                    HStack(spacing: 5) {
                        Image(systemName: "sun.max.fill").font(.system(size: 10)).foregroundColor(.gray)
                        Text(reminder.lightDetails).font(.caption).foregroundColor(.gray)
                    }
                    
                    // Water التفاصيل
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

// Struct لزر التصفية
struct FilterButton: View {
    let title: String
    @Binding var selectedFilter: String
    var isSelected: Bool { title == selectedFilter }
    
    var body: some View {
        Button(action: { selectedFilter = title }) {
            Text(title).font(.caption).bold().padding(.vertical, 8).padding(.horizontal, 15)
                .background(RoundedRectangle(cornerRadius: 15).fill(isSelected ? Color("green1") : Color(white: 0.15)))
                .foregroundColor(isSelected ? .black : .gray)
        }
    }
}

#Preview {
    TodayReminderView()
}
