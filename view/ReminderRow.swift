//
//  ReminderRow.swift
//  plant
//
//  Created by Layan on 05/05/1447 AH.
//


import SwiftUI

struct ReminderRow: View {
    @Binding var reminder: PlantReminder

    var foregroundColor: Color { reminder.isCompleted ? .gray : .white }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(reminder.isCompleted ? Color("green1") : .gray)
                .onTapGesture {
                    withAnimation(.spring()) {
                        reminder.isCompleted.toggle()
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

                Text(reminder.name)
                    .font(.headline)
                    .foregroundColor(foregroundColor)

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