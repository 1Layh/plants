//
//  PlantReminder 2.swift
//  plant
//
//  Created by Layan on 04/05/1447 AH.
//


import SwiftUI

// =========================================================
// Structs الأساسية والبيانات (Data Models and Logic)
// =========================================================

struct PlantReminder: Identifiable {
    let id = UUID()
    let name: String
    let details: String
    let locationIcon: String
    var isCompleted: Bool = false
    let room: String = "Kitchen"
    let lightDetails: String = "Full sun"
    let waterAmount: String = "20-50 ml"
}

// مركز البيانات (ObservableObject)
class PlantData: ObservableObject {
    @Published var todayReminders: [PlantReminder] = [
        PlantReminder(name: "Monstera", details: "Water at 09:00 AM", locationIcon: "drop.fill", isCompleted: false),
        PlantReminder(name: "Pothos", details: "Fertilize at 3:00 PM", locationIcon: "drop.fill", isCompleted: true),
        PlantReminder(name: "Orchid", details: "Mist leaves now", locationIcon: "drop.fill", isCompleted: true)
    ]
    
    func addReminder(plant: PlantReminder) {
        withAnimation {
            todayReminders.append(plant)
        }
    }
    
    // ✅ الدالة المصححة لحل خطأ Binding
    func binding(for reminder: PlantReminder) -> Binding<PlantReminder> {
        guard let index = todayReminders.firstIndex(where: { $0.id == reminder.id }) else {
            fatalError("Can't find reminder in array")
        }
        return $todayReminders[index]
    }
}

// =========================================================
// Structs الخاصة بخيارات الـ Picker (SetReminderView Options)
// =========================================================

struct LightOption: Identifiable, Hashable { let id = UUID(); let name: String; let icon: String }
struct Option: Identifiable, Hashable { let id = UUID(); let name: String }

let WateringDaysOptions = [ Option(name: "Every day"), Option(name: "Every 2 days"), Option(name: "Every 3 days"), Option(name: "Once a week"), Option(name: "Every 10 days"), Option(name: "Every 2 weeks") ]
let WaterAmountOptions = [ Option(name: "20-50 ml"), Option(name: "50-100 ml"), Option(name: "100-200 ml"), Option(name: "200-300 ml") ]
let RoomOptions = [ Option(name: "Bedroom"), Option(name: "Living Room"), Option(name: "Kitchen"), Option(name: "Balcony"), Option(name: "Bathroom") ]
let LightOptions = [ LightOption(name: "Full sun", icon: "sun.max"), LightOption(name: "Partial Sun", icon: "sun.haze"), LightOption(name: "Low Light", icon: "moon") ]


// =========================================================
// Structs المساعدة (UI Components)
// =========================================================

struct PickerRow<SelectionValue: Hashable, Content: View>: View {
    let title: String
    @Binding var selection: SelectionValue
    let icon: Image
    let content: Content

    init(title: String, selection: Binding<SelectionValue>, icon: Image, @ViewBuilder content: () -> Content) {
        self.title = title
        self._selection = selection
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        HStack {
            icon.frame(width: 15).foregroundColor(.white)
            Text(title).foregroundColor(.white).frame(width: 120, alignment: .leading)
            
            Spacer()

            Picker(title, selection: $selection) { content }
            .pickerStyle(.menu)
            .foregroundColor(.gray)
            .labelsHidden()
        }
        .padding(.vertical, 10)
    }
}

struct GroupedSectionView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(spacing: 0) { content }
        .padding(.horizontal, 15)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.15)))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
