//
//  CateguryArray.swift
//  Ozinshe
//
//  Created by Alina Floccus on 23.12.2023.
//

import Foundation
import SwiftyJSON

//   {
//       "id": 1,
//       "name": "8-10",
//       "fileId": 353,
//       "link": "http://api.ozinshe.com/core/public/V1/show/353",
//       "movieCount": null
//    }

class CategoryAge {
    public var id: Int = 0
    public var name: String = ""
    public var link: String = ""
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["link"].string {
            self.link = temp
        }
    }
}
