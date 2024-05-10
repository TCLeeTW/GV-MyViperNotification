//
//  Entity.swift
//  MyViperNotification
//
//  Created by TC on 2024/5/9.
//

import Foundation

// Model

struct User:Codable{
    let name:String
}
enum Updateable:String,Codable{
    case required="required"
    case suggested="suggested"
    case latest="latest"
}
