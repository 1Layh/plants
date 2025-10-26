//
//  SetReminderView.swift
//  plant
//
//  Created by Layan on 29/04/1447 AH.
//
import SwiftUI


struct TextFieldRow: View {
    let title: String
    @Binding var value: String
    let icon: Image?

    var body: some View {
        HStack {
            if let icon = icon {
                icon.frame(width: 15).foregroundColor(.gray)
            }
            Text(title).foregroundColor(.gray).frame(width: 120, alignment: .leading)
            Spacer()
            Text(value).foregroundColor(.white)
            Image(systemName: "chevron.right").foregroundColor(.gray).font(.system(size: 10, weight: .semibold))
        }
        .padding(.vertical, 10)
    }
}


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

            Picker(title, selection: $selection) {
                content
            }
            .pickerStyle(.menu)
            .foregroundColor(.gray)
            .labelsHidden()
        }
        .padding(.vertical, 10)
    }
}

// ... (Structs GroupedSectionView و Extensions كما في الكود السابق)
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


struct LightOption: Identifiable, Hashable { let id = UUID(); let name: String; let icon: String }
struct Option: Identifiable, Hashable { let id = UUID(); let name: String }

let WateringDaysOptions = [ Option(name: "Every day"), Option(name: "Every 2 days"), Option(name: "Every 3 days"), Option(name: "Once a week"), Option(name: "Every 10 days"), Option(name: "Every 2 weeks") ]
let WaterAmountOptions = [ Option(name: "20-50 ml"), Option(name: "50-100 ml"), Option(name: "100-200 ml"), Option(name: "200-300 ml") ]
let RoomOptions = [ Option(name: "Bedroom"), Option(name: "Living Room"), Option(name: "Kitchen"), Option(name: "Balcony"), Option(name: "Bathroom") ]
let LightOptions = [ LightOption(name: "Full sun", icon: "sun.max"), LightOption(name: "Partial Sun", icon: "sun.haze"), LightOption(name: "Low Light", icon: "moon") ]



struct SetReminderView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: (PlantReminder) -> Void
    
    @State private var plantName: String = ""
    @State private var selectedRoom = RoomOptions[0]
    @State private var selectedLight = LightOptions[0]
    @State private var selectedWateringDays = WateringDaysOptions[0]
    @State private var selectedWaterAmount = WaterAmountOptions[0]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        HStack {
                            Text("Plant Name").foregroundColor(.white).frame(alignment: .leading)
                            TextField("Enter Name", text: $plantName).foregroundColor(.white).multilineTextAlignment(.trailing)
                            }
                        .padding(.vertical, 20).padding(.horizontal, 15)
                        .background(RoundedRectangle(cornerRadius: 32).fill(Color(white: 0.15)))
                            
                        // قسم الغرفة والإضاءة
                        GroupedSectionView {
                            PickerRow(title: "Room", selection: $selectedRoom, icon: Image(systemName: "paperplane.fill")) {
                                ForEach(RoomOptions) { option in Text(option.name).tag(option) }
                            }
                            Divider().background(Color(white: 0.3))
                            
                            PickerRow(title: "Light", selection: $selectedLight, icon: Image(systemName: "sun.max.fill")) {
                                ForEach(LightOptions) { option in HStack { Image(systemName: option.icon); Text(option.name) }.tag(option) }
                            }
                        }
                            
                        // قسم الري
                        GroupedSectionView {
                            PickerRow(title: "Watering Days", selection: $selectedWateringDays, icon: Image(systemName: "drop.fill")) {
                                ForEach(WateringDaysOptions) { option in Text(option.name).tag(option) }
                            }
                            Divider().background(Color(white: 0.3))
                            
                            PickerRow(title: "Water", selection: $selectedWaterAmount, icon: Image(systemName: "drop.fill")) {
                                ForEach(WaterAmountOptions) { option in Text(option.name).tag(option) }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 15).padding(.horizontal, 15).padding(.bottom, 30)
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
            .background(Color(white: 0.1)).cornerRadius(25, corners: [.topLeft, .topRight]).padding(.top, 30)
        }
        .preferredColorScheme(.dark)
    }
    
    var headerView: some View {
        HStack {
            // زر الإغلاق (X) - Liquid Glass
            Button(action: { dismiss() }) {
                Image(systemName: "xmark").font(.system(size: 14, weight: .bold)).padding(8).background(Color.clear).foregroundColor(.white)
            }
            .buttonStyle(.glassProminent).tint(Color("X")).clipShape(Circle())
                
            Spacer()
            Text("Set Reminder").font(.headline).foregroundColor(.white)
            Spacer()
                
            // زر الصح (للحفظ) - Liquid Glass
            Button(action: {
                let plantDetails = "Room: \(selectedRoom.name), Light: \(selectedLight.name), Water: \(selectedWateringDays.name) (\(selectedWaterAmount.name))"
                let newPlant = PlantReminder(
                    name: plantName.isEmpty ? "New Plant" : plantName,
                    details: plantDetails,
                    locationIcon: "drop.fill"
                )
                
                onSave(newPlant)
                
                dismiss()
            }) {
                Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)).padding(8).background(Color.clear).foregroundColor(.white)
            }
            .buttonStyle(.glassProminent).tint(Color("green1")).clipShape(Circle())
            .disabled(plantName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 25).padding(.vertical, 20).background(Color(white: 0.1))
    }
}

#Preview {
    SetReminderView(onSave: { _ in })
}
