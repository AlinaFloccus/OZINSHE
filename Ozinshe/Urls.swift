//
//  Urls.swift
//  Ozinshe
//
//  Created by Alina Floccus on 21.12.2023.
//

import Foundation

class Urls {
    // static вложенность ради вложенности
    static let BASE_URL = "http://api.ozinshe.com/core/V1/"
    
    static let SIGN_IN_URL = "http://api.ozinshe.com/auth/V1/signin"
    static let FAVORITE_URL = BASE_URL + "favorite/"
    static let CATEGORIES_URL = BASE_URL + "categories"
    static let SEARCH_MOVIES_URL = BASE_URL + "movies/search"
    static let MOVIES_BY_CATEGORY_URL = BASE_URL + "movies/page"
    static let MAIN_MOVIES_URL = BASE_URL + "movies/main"
    static let MAIN_BANNERS_URL = BASE_URL + "movies_main"
    static let USER_HISTORY_URL = BASE_URL + "history/userHistory"
    static let GET_GENRES = BASE_URL + "genres"
    static let GET_AGES = BASE_URL + "category-ages"
}

