//
//  Movie.swift
//  Ozinshe
//
//  Created by Alina Floccus on 23.12.2023.
//

import Foundation
import SwiftyJSON

//"id": 86,
//        "movieType": "MOVIE",
//        "name": "Түлкі мен бөдене",
//        "keyWords": "Түлкі мен бөдене",
//        "description": "Түлкі мен бөдене описание описание описание описание описание описание описание описание описание описание ",
//        "year": 2021,
//        "trend": true,
//        "timing": 6,
//        "director": "--Режиссер--",
//        "producer": "--Продюсер--",
//        "poster": {
//            "id": 84,
//            "link": "http://api.ozinshe.com/core/public/V1/show/525",
//            "fileId": 525,
//            "movieId": 86
//        },
//        "video": {
//            "id": 310,
//            "link": "8T3pBbtTASc",
//            "seasonId": null,
//            "number": 0
//        },
//        "watchCount": 1,
//        "seasonCount": 0,
//        "seriesCount": 0,
//        "createdDate": "2022-01-12T12:53:11.722+00:00",
//        "lastModifiedDate": "2022-01-20T06:08:17.837+00:00",
//        "screenshots": [
//            {
//                "id": 101,
//                "link": "http://api.ozinshe.com/core/public/V1/show/526",
//                "fileId": 526,
//                "movieId": 86
//            },
//            {
//                "id": 102,
//                "link": "http://api.ozinshe.com/core/public/V1/show/527",
//                "fileId": 527,
//                "movieId": 86
//            },
//            {
//                "id": 103,
//                "link": "http://api.ozinshe.com/core/public/V1/show/528",
//                "fileId": 528,
//                "movieId": 86
//            }
//        ],
//        "categoryAges": [
//            {
//                "id": 1,
//                "name": "8-10",
//                "fileId": 353,
//                "link": "http://api.ozinshe.com/core/public/V1/show/353",
//                "movieCount": null
//            }
//        ],
//        "genres": [
//            {
//                "id": 4,
//                "name": "Ойын-сауық",
//                "fileId": 360,
//                "link": "http://api.ozinshe.com/core/public/V1/show/360",
//                "movieCount": null
//            }
//        ],
//        "categories": [
//            {
//                "id": 5,
//                "name": "Телехикаялар",
//                "fileId": null,
//                "link": "http://api.ozinshe.com/core/public/V1/show/null",
//                "movieCount": null
//            }
//        ],
//        "favorite": true

class Movie {
    public var id: Int = 0
    public var movieType: String = ""
    public var name: String = ""
    public var keyWords: String = ""
    public var description: String = ""
    public var year: Int = 0
    public var trend: Bool = false
    public var timing: Int = 0
    public var director: String = ""
    public var producer: String = ""
    public var poster_link: String = ""
    public var video_link: String = ""
    public var watchCount: Int = 0
    public var seasonCount: Int = 0
    public var seriesCount: Int = 0
    public var createdDate: String = ""
    public var lastModifiedDate: String = ""
    public var screenshots: [Screenshot] = []
    public var categoryAges: [CategoryAge] = []
    public var genres: [Genre] = []
    public var categories: [Category] = []
    public var favorite: Bool = false
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["movieType"].string {
            self.movieType = temp
        }
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["keyWords"].string {
            self.keyWords = temp
        }
        if let temp = json["description"].string {
            self.description = temp
        }
        if let temp = json["year"].int {
            self.year = temp
        }
        if let temp = json["trend"].bool {
            self.trend = temp
        }
        if let temp = json["timing"].int {
            self.timing = temp
        }
        if let temp = json["director"].string {
            self.director = temp
        }
        if let temp = json["producer"].string {
            self.producer = temp
        }
        if json["poster"].exists() {
            if let temp = json["poster"]["link"].string {
                self.poster_link = temp
            }
        }
        if json["video"].exists() {
            if let temp = json["video"]["link"].string {
                self.video_link = temp
            }
        }
        if let temp = json["watchCount"].int {
            self.watchCount = temp
        }
        if let temp = json["seasonCount"].int {
            self.seasonCount = temp
        }
        if let temp = json["seriesCount"].int {
            self.seriesCount = temp
        }
        if let temp = json["createdDate"].string {
            self.createdDate = temp
        }
        if let temp = json["lastModifiedDate"].string {
            self.lastModifiedDate = temp
        }
        if let array = json["screenshots"].array {
            for item in array {
                let temp = Screenshot(json: item)
                self.screenshots.append(temp)
            }
        }
        if let array = json["categoryAges"].array {
            for item in array {
                let temp = CategoryAge(json: item)
                self.categoryAges.append(temp)
            }
        }
        if let array = json["genres"].array {
            for item in array {
                let temp = Genre(json: item)
                self.genres.append(temp)
            }
        }
        if let array = json["categories"].array {
            for item in array {
                let temp = Category(json: item)
                self.categories.append(temp)
            }
        }
        if let temp = json["favorite"].bool {
            self.favorite = temp
        }
    }
}
