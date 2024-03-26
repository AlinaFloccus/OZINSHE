//
//  MainMovies.swift
//  Ozinshe
//
//  Created by Alina Floccus on 18.02.2024.
//

import Foundation
import SwiftyJSON

enum CellType {
    case mainBanner
    case mainMovie
    case userHistory
    case genre
    case ageCategory
}

class MainMovies {
    var categoryId = 0
    var categoryName = ""
    var movies: [Movie] = []
    // добавляем дополнительно
    var bannerMovie: [BannerMovie] = []
    var cellType: CellType = .mainMovie //? I don't understant this
    var categoryAges: [CategoryAge] = []
    var genres: [Genre] = []
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["categoryId"].int {
            self.categoryId = temp
        }
        if let temp = json["categoryName"].string {
            self.categoryName = temp
        }
        if let array = json["movies"].array {
            for item in array {
                let temp = Movie(json: item)
                self.movies.append(temp)
            }
        }
        
    }
    
}
