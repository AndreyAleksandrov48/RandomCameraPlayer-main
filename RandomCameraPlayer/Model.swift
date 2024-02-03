//
//  Model.swift
//  RandomCameraPlayer
//
//  Created by Andrew on 04.11.2023.
//

import Foundation
import SwiftData



@Model

final class DataModel{
    @Attribute (.unique) var savedLink: URL
    var id: UUID
    var date: Date
    
    
    
    
    init(savedLink: URL, id: UUID, date: Date) {
        self.savedLink = savedLink
        self.id = id
        self.date = date
    }
}

