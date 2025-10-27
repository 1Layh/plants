//
//  SetReminderView.swift
//  plant
//
//  Created by Layan on 29/04/1447 AH.
//

import SwiftUI

struct SetReminderView: View {
    @Environment(\.dismiss) var dismiss

    // Modes
    let reminderToEdit: PlantReminder?
    var onSave: ((PlantReminder) -> Void)?
    var onUpdate: ((PlantReminder) -> Void)?
    var onDelete: ((UUID) -> Void)?

    // Inputs
    @State private var plantName: String = ""
    @State private var room: String = "Bedroom"
    @State private var light: String = "Full Sun"
    @State private var wateringDays: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"

    // Options
    private let roomOptions = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    private let lightOptions = ["Full Sun", "Partial Sun", "Low Light"]
    private let wateringOptions = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    private let waterOptions = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]

    private var isEditMode: Bool { reminderToEdit != nil }

    init(
        reminderToEdit: PlantReminder?,
        onSave: ((PlantReminder) -> Void)?,
        onUpdate: ((PlantReminder) -> Void)?,
        onDelete: ((UUID) -> Void)?
    ) {
        self.reminderToEdit = reminderToEdit
        self.onSave = onSave
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        // State will be set in .onAppear to keep SwiftUI happy
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView

                ScrollView {
                    VStack(spacing: 20) {
                        // Plant name - only in Add mode
                        if !isEditMode {
                            HStack {
                                Text("Plant Name")
                                    .foregroundColor(.white)
                                TextField("Enter Name", text: $plantName)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading) // leading for English typing feel
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled(true)
                                    .keyboardType(.default)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 15)
                            .background(liquidBackground(corner: 32))
                        }

                        // Group 1: Room + Light
                        GroupedSectionView {
                            MenuRow(
                                icon: Image(systemName: "paperplane.fill"),
                                title: "Room",
                                selection: $room,
                                options: roomOptions
                            )

                            Divider().background(Color(white: 0.25))

                            MenuRow(
                                icon: Image(systemName: "sun.max"),
                                title: "Light",
                                selection: $light,
                                options: lightOptions
                            )
                        }

                        // Group 2: Watering Days + Water
                        GroupedSectionView {
                            MenuRow(
                                icon: Image(systemName: "drop"),
                                title: "Watering Days",
                                selection: $wateringDays,
                                options: wateringOptions
                            )

                            Divider().background(Color(white: 0.25))

                            MenuRow(
                                icon: Image(systemName: "drop"),
                                title: "Water",
                                selection: $waterAmount,
                                options: waterOptions
                            )
                        }

                        // Delete button appears only in Edit mode
                        if isEditMode {
                            Button(role: .destructive) {
                                if let id = reminderToEdit?.id {
                                    onDelete?(id)
                                }
                                dismiss()
                            } label: {
                                Text("Delete Reminder")
                                    .font(.system(size: 17, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color(white: 0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 18)
                                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                            )
                                    )
                            }
                            .tint(.red)
                            .padding(.top, 8)
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 30)
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
            .background(Color(white: 0.1))
            .cornerRadius(25, corners: [.topLeft, .topRight])
            .padding(.top, 30)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if let edit = reminderToEdit {
                // Pre-fill for edit
                plantName = edit.name
                room = edit.room
                light = edit.lightDetails
                wateringDays = parseDays(from: edit.details) ?? "Every day"
                waterAmount = edit.waterAmount
            }
        }
    }

    // Header with liquid buttons
    var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .padding(8)
                    .foregroundColor(.white)
            }
            .buttonStyle(.glassProminent)
            .tint(Color("X"))
            .clipShape(Circle())

            Spacer()

            Text("Set Reminder")
                .font(.headline)
                .foregroundColor(.white)

            Spacer()

            Button(action: {
                if isEditMode, let original = reminderToEdit {
                    // Update existing
                    let updated = PlantReminder(
                        id: original.id,
                        name: original.name, // ثابت في وضع التعديل
                        details: "Days: \(wateringDays), Amount: \(waterAmount), Light: \(light), Room: \(room)",
                        locationIcon: original.locationIcon,
                        isCompleted: original.isCompleted,
                        room: room,
                        lightDetails: light,
                        waterAmount: waterAmount
                    )
                    onUpdate?(updated)
                } else {
                    // Add new
                    let reminder = PlantReminder(
                        name: plantName.isEmpty ? "Plant" : plantName,
                        details: "Days: \(wateringDays), Amount: \(waterAmount), Light: \(light), Room: \(room)",
                        locationIcon: "paperplane.fill",
                        isCompleted: false,
                        room: room,
                        lightDetails: light,
                        waterAmount: waterAmount
                    )
                    onSave?(reminder)
                }
                dismiss()
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .padding(8)
                    .foregroundColor(.white)
            }
            .buttonStyle(.glassProminent)
            .tint(Color("green1"))
            .clipShape(Circle())
            .disabled(!isEditMode && plantName.isEmpty)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 20)
        .background(Color(white: 0.1))
    }

    // Helper: liquid background
    private func liquidBackground(corner: CGFloat = 12) -> some View {
        RoundedRectangle(cornerRadius: corner)
            .fill(Color(white: 0.15))
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 8)
    }

    // Optional: parse days from details string if needed
    private func parseDays(from details: String) -> String? {
        // details format: "Days: X, Amount: Y, Light: Z, Room: R"
        guard let range = details.range(of: "Days: ") else { return nil }
        let rest = details[range.upperBound...]
        if let comma = rest.firstIndex(of: ",") {
            return String(rest[..<comma]).trimmingCharacters(in: .whitespaces)
        }
        return nil
    }
}

struct MenuRow: View {
    let icon: Image?
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    HStack {
                        Text(option)
                        if option == selection {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                if let icon = icon {
                    icon
                        .frame(width: 15)
                        .foregroundColor(.gray)
                }
                Text(title)
                    .foregroundColor(.white)

                Spacer()

                Text(selection)
                    .foregroundColor(.gray)

                Image(systemName: "chevron.up.chevron.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 11, weight: .semibold))
            }
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
    }
}

struct GroupedSectionView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .padding(.horizontal, 15)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(white: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 8)
        )
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
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    // Preview add mode
    SetReminderView(reminderToEdit: nil, onSave: { _ in }, onUpdate: nil, onDelete: nil)
}
