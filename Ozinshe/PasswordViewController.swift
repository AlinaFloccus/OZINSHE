//
//  PasswordViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 25.11.2023.
//

import UIKit
import Alamofire
import SVProgressHUD

class PasswordViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTextField: TexFieldWithPadding!
    @IBOutlet weak var repeatPasswordTextField: TexFieldWithPadding!
    @IBOutlet weak var chandeButton: UIButton!
    
    @IBOutlet weak var passwordTextButton: UIButton!
    @IBOutlet weak var repeatPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureteViews()
        hideKeyboardWhenTappedAround()
    }
    
    // настройки для элементов интерфейса
    func configureteViews(){
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        repeatPasswordTextField.layer.cornerRadius = 12.0
        repeatPasswordTextField.layer.borderWidth = 1.0
        repeatPasswordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        chandeButton.layer.cornerRadius = 12.0
       
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // при работе с инпутом
    @IBAction func textFieldEditingDidBegin(_ sender: TexFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.0).cgColor
    }
    
    // когда убрали наведение с инпута
    @IBAction func textFieldEditingDidEnd(_ sender: TexFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
    }
    
    // показать пароль
    @IBAction func showPassword(_ sender: UIButton) {
        if sender == passwordTextButton {
            passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        } else if sender == repeatPasswordButton {
            repeatPasswordTextField.isSecureTextEntry = !repeatPasswordTextField.isSecureTextEntry
        }
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        let password = passwordTextField.text!
        let repeatPassword = repeatPasswordTextField.text!
        
        // не давать нажать на кнопку, если не совпадают пароли
        if password != repeatPassword {
            return
        }
        
        let parametrs = [
            "password": password
        ]
        
        AF.request("http://api.ozinshe.com/core/V1/user/profile/changePassword", method: .put, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            var resultString = ""
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
