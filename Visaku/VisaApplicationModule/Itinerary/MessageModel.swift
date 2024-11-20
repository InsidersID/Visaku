//
//  MessageModel.swift
//  attemp1
//
//  Created by Nur Nisrina on 01/11/24.
//

import Foundation

struct MessageModel: Identifiable , Codable{
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}
