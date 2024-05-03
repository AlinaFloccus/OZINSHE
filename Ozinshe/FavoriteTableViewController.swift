//
//  FavoriteTableViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 02.11.2023.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class FavoriteTableViewController: UITableViewController {
    
//    var arrayFavorite = ["image1", "image2", "image3"]
    var favorites:[Movie] = []

    // viewDidLoad - вызывается единожды
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // забрать карточку фильма из компонента проекта
        let MovieCellnib = UINib(nibName: "MovieCell",bundle: nil)
        tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
    }
    
    // viewDidAppear заменили на viewWillAppear - при каждом появлении этого экрана - обновлять данные
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadFavorites()
    }
    
    func downloadFavorites() {
        SVProgressHUD.show()
        
        // передать token бэкенду
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.FAVORITE_URL, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            // логирование ответа с бэка в консоль
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            if response.response?.statusCode == 200 {
                // парсим json для swift
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                // говорим: то что пришло с бэка - это массив из объектов
                if let array = json.array {
                    // перебераем массив и конвертируем в swift модель
                    self.favorites.removeAll() // если не будет этой части, то он будет сверху добавлять тоже самое
                    for item in array {
                        let movie = Movie(json: item)
                        self.favorites.append(movie)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell

        // Configure the cell...
        cell.setData(movie: favorites[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieinfoVC.movie = favorites[indexPath.row]
        navigationController?.show(movieinfoVC, sender: self)
    }
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
