//
//  MainPageViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 18.02.2024.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieProtocol, GenreAgeProtocol {
    func didSelectGenreAge(_ genreAge: CategoryAge) {
        // TODO: переписать, чтобы открывал страницу с категорией
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        
        
        
        navigationController?.show(movieinfoVC, sender: self)
    }
    
 
    @IBOutlet weak var tableView: UITableView!
    
    var mainMovies:[MainMovies] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        addNavBarImage()
        
        downloadMainBanners()
    }
    
    func addNavBarImage() {
        let image = UIImage(named: "logoMainPage")!
        
        // создвем новый ImageView с картинкой и добавляем его, как UIBarButtonItem
        let logoImageView = UIImageView(image: image)
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        navigationItem.leftBarButtonItem = imageItem
    }
    
// MARK: - downlands
    
    // сначала скачиваем основные баннеры
    func downloadMainBanners() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.MAIN_BANNERS_URL, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .mainBanner // не понимаю как работает ;(
                    for item in array {
                        let bannerMovie = BannerMovie(json: item)
                        movie.bannerMovie.append(bannerMovie) // не понимаю ;(
                    }
                    self.mainMovies.append(movie)
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            self.downloadUserHistory()
        }
    }
    
    // 2 шаг - скачиваем историю просмотров, если есть
    func downloadUserHistory() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.USER_HISTORY_URL, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .userHistory
                    for item in array {
                        let historyMovie = Movie(json: item)
                        movie.movies.append(historyMovie)
                    }
                    // проверяем есть ли история
                    if array.count > 0 {
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            self.downloadMainMovies()
        }
    }
    
    // скачиваем фильмы по категориям
    func downloadMainMovies() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.MAIN_MOVIES_URL, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let movie = MainMovies(json: item)
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".lowercased())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            self.downloadGenres()
        }
    }
    
    // скачиваем жанры ии ставим 4-ой строчкой
    func downloadGenres() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_GENRES, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    let movie = MainMovies()
                    movie.cellType = .genre
                    for item in array {
                        let genre = Genre(json: item)
                        movie.genres.append(genre) // не понимаю ;(
                    }
                    // ставим 4-ым блоком
                    if self.mainMovies.count > 4 {
                        if self.mainMovies[1].cellType == .userHistory { // не понимаю ;(
                            self.mainMovies.insert(movie, at: 4) // не понимаю ;(
                        } else {
                            self.mainMovies.insert(movie, at: 3)
                        }
                    } else {
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
            self.downloadCategoryAges()
        }
    }
    
    // скачиваем категории по возрастам и ставим 8-ой строчкой
    func downloadCategoryAges() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.GET_AGES, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array { // если от сервера получим массив
                    let movie = MainMovies() // перебираем массив и по 1 элементу добавляем
                    movie.cellType = .ageCategory // при рендере берем именно ageCategory
                    for item in array {
                        let ageCategory = CategoryAge(json: item)
                        movie.categoryAges.append(ageCategory)
                    }
                    // ставим 8-ым блоком
                    if self.mainMovies.count > 8 { // индеекс начинается с нуля, поэтому 8
                        if self.mainMovies[1].cellType == .userHistory { // если во втором блоке есть история, то рендерем наш дизайн ячейки под userHistory
                            self.mainMovies.insert(movie, at: 8) // вставляем 9 строчкой
                        } else {
                            self.mainMovies.insert(movie, at: 7)
                        }
                    } else {
                        self.mainMovies.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    // метод определяет количество секций в таблице. Если он не реализован, по умолчанию используется одна секция
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //метод в UITableViewDataSource вызывается для получения количества строк в указанной секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mainMovies.count
    }
    
    // метод вызывается для получения ячейки, которая будет отображаться в указанном индексе
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // главные баннера
        if mainMovies[indexPath.row].cellType == .mainBanner {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainBannerCell", for: indexPath) as! MainBannerTableViewCell
            
            cell.setData(mainMovie: mainMovies[indexPath.row])
            cell.delegate = self // ячейка будет обращаться к MainPageViewController и использовать  Protocol "Movie"
            
            return cell
        }
        
        // история просмотров
        if mainMovies[indexPath.row].cellType == .userHistory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell

            cell.setData(mainMovie: mainMovies[indexPath.row])
           cell.delegate = self

            return cell
        }
        
        // категории жанров или категории по возрастам
        if mainMovies[indexPath.row].cellType == .genre || mainMovies[indexPath.row].cellType == .ageCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "genreAgeCell", for: indexPath) as! GenreAgeTableViewCell

            cell.setData(mainMovie: mainMovies[indexPath.row])
            cell.delegate = self
            
            return cell
        }
        
        // список фильмов по категориям
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        cell.setData(mainMovie: mainMovies[indexPath.row]) // setData - передаем конкретный эллемент от mainMovie
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mainMovies[indexPath.row].cellType == .mainBanner {
            return 272.0
        }
        if mainMovies[indexPath.row].cellType == .userHistory {
            return 228.0
        }
        if mainMovies[indexPath.row].cellType == .genre || mainMovies[indexPath.row].cellType == .ageCategory {
            return 184.0
        }
        
        // mainMovie
        return 296.0
    }
    
    // функция при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainMovies[indexPath.row].cellType != .mainMovie { // не понимаю ;(
            return
        }
        // не понимаю ;(
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = mainMovies[indexPath.row].categoryId
        categoryTableViewController.categoryName = mainMovies[indexPath.row].categoryName
        
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
    // MARK: - MovieProtocol
    func movieDidSelect(movie: Movie) {
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieinfoVC.movie = movie
        
        navigationController?.show(movieinfoVC, sender: self)
    }

}
