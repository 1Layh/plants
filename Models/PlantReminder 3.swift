//
//  PlantReminder 3.swift
//  plant
//
//  Created by Layan on 05/05/1447 AH.
//

import Foundation

struct PlantReminder: Identifiable, Equatable {
    let id: UUID
    let name: String
    let details: String
    let locationIcon: String
    var isCompleted: Bool
    let room: String
    let lightDetails: String
    let waterAmount: String
 
    init(
        id: UUID = UUID(),
        name: String,
        details: String,
        locationIcon: String,
        isCompleted: Bool = false,
        room: String,
        lightDetails: String,
        waterAmount: String
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.locationIcon = locationIcon
        self.isCompleted = isCompleted
        self.room = room
        self.lightDetails = lightDetails
        self.waterAmount = waterAmount
    }
}
