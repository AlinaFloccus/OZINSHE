//
//  PersonalDataViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 25.11.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PersonalDataViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var yearField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
    }
    
    /*
     "id": 25022,
       "user": {
         "id": 25044,
         "email": "nurasylmelsuly@gmail.com"
       },
       "name": "Nurasyl",
       "phoneNumber": "11111111111",
       "birthDate": "2023-12-31",
       "language": null
     */
    
    // получить данные
    func downloadData() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request("http://api.ozinshe.com/core/V1/user/profile/", method: .get, headers: headers).responseData { response in
            
            var resultString = ""
            // чтобы выводить ошибки от сервера. resultString - просто переменная, в которую прелетает responsebody
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                
                self.nameField.text = json["name"].stringValue
                self.emailField.text = json["user"]["email"].stringValue
                self.phoneField.text = json["phoneNumber"].stringValue
                /*
                 self.idField.text = String(json["id"].intValue)
                 */
                self.yearField.text = json["birthDate"].stringValue
            
            } else {
                SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
        }
            
        }
    }
    
    
    // обновить данные
    @IBAction func saveButton(_ sender: Any) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        let name = nameField.text!
        let phoneNumber = phoneField.text!
        let birthDate = yearField.text!
        
        let parametrs = [
            // "field back": field front
            "name": name,
            "phoneNumber": phoneNumber,
            "birthDate": birthDate,
        ]

        // через передаем новые значения
        AF.request("http://api.ozinshe.com/core/V1/user/profile/", method: .put, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            var resultString = ""
            // чтобы выводить ошибки от сервера. resultString - просто переменная, в которую прелетает responsebody
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                
                // убирает последний экран и возвращает обратно popViewController
                self.navigationController?.popViewController(animated: true)
                
            } else {
                SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
            }
    
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
