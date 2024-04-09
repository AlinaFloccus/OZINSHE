//
//  SearchViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 08.02.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

// для выравнивание по левому краю категорий
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var searchTextField: TexFieldWithPadding!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewToLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToCollectionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var clearButton: UIButton!
    
    var categories:[Category] = []
    
    var movies:[Movie] = []
    
    var request: Request? //?-что по-умолчанию ничеге нет. переменная для того чтобы хранить в нем запрос, который сейчас происходит, а при новом запросе завершать первый
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        downloadCategories()
    }
    
    // MARK: - Configure Views
    func configureViews() {
        //collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // задаем расстояния между табами "категории"
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8 // расстояние между табами по горизонтали
        layout.minimumLineSpacing = 16 // расстояние между табами по вертикали
        layout.estimatedItemSize.width = 100 // обязательный элемент, чтобы не слипались табы?
        collectionView.collectionViewLayout = layout
        
        //searchTextField
        searchTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        searchTextField.layer.cornerRadius = 12.0
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
    
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        let MovieCellnib = UINib(nibName: "MovieCell",bundle: nil)
        tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: TexFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: TexFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    

    @IBAction func textFieldDidChanged(_ sender: Any) {
        downloadSearchMovies()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func clearTextField(_ sender: Any) {
        searchTextField.text = ""
        downloadSearchMovies()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        downloadSearchMovies()
    }
    
    // MARK: - downloadSearchMovies
    func downloadSearchMovies() {
        
        // если инпут пустой
        if searchTextField.text!.isEmpty {
            topLabel.text = "Санаттар"
            collectionView.isHidden = false
            tableViewToLabelConstraint.priority = .defaultLow
            tableViewToCollectionConstraint.priority = .defaultHigh
            tableView.isHidden = true
            movies.removeAll()
            tableView.reloadData()
            clearButton.isHidden = true
            return // остановить функцию
        }
        // если инпут не пустой
        topLabel.text = "Іздеу нәтижелері"
        collectionView.isHidden = true
        tableViewToLabelConstraint.priority = .defaultHigh
        tableViewToCollectionConstraint.priority = .defaultLow
        tableView.isHidden = false
        clearButton.isHidden = false
        
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        let parameters = ["search": searchTextField.text!]
        
        request?.cancel() //чтобы отменить предыдущий запрос
        //присваиваем новый запрос
        request = AF.request(Urls.SEARCH_MOVIES_URL, method: .get, parameters: parameters, headers: headers).responseData { response in
            
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
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    for item in array {
                        let movie = Movie(json: item)
                        self.movies.append(movie)
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
             //   SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    // MARK: - downloadCategories
    func downloadCategories() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(Urls.CATEGORIES_URL, method: .get, headers: headers).responseData { response in
            
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
                        let category = Category(json: item)
                        self.categories.append(category)
                    }
                    self.collectionView.reloadData()
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

    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = categories[indexPath.row].name
        
        let backgroundview = cell.viewWithTag(1000)
        backgroundview!.layer.cornerRadius = 8
        
        return cell
    }
    
    // функция при нажатии на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = categories[indexPath.row].id
        categoryTableViewController.categoryName = categories[indexPath.row].name
        
        navigationController?.show(categoryTableViewController, sender: self)
    }
    
    // MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell

        cell.setData(movie: movies[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    
    // нажатие на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieinfoVC.movie  = movies[indexPath.row]
        
        navigationController?.show(movieinfoVC, sender: self)
    }
}
