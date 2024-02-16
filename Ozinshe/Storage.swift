//
//  Storage.swift
//  Ozinshe
//
//  Created by Alina Floccus on 21.12.2023.
//

import Foundation
import UIKit

class Storage {
    // хранит в себе статичный токен
    public var accessToken: String = ""
    
    // и sharedInstance самого себя. чтобы обращаясь с любого из экранов к токену, он был всегда один (когда мы создаем класс в ед. экземпляря, нода использовать sharedInstance
    // static, чтобы не было рекурссии
    static let sharedInstance = Storage()
}
