//
//  SignUpViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 30.04.2024.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: TexFieldWithPadding!
    @IBOutlet weak var passwordTextField: TexFieldWithPadding!
    @IBOutlet weak var copyPasswordTextField: TexFieldWithPadding!
    
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var copyPasswordButton: UIButton!

    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureteViews()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    // настройки для элементов интерфейса
    func configureteViews(){
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        copyPasswordTextField.layer.cornerRadius = 12.0
        copyPasswordTextField.layer.borderWidth = 1.0
        copyPasswordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        signupButton.layer.cornerRadius = 12.0
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
        if sender == passwordButton {
            passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        } else if sender == copyPasswordButton {
            copyPasswordTextField.isSecureTextEntry = !copyPasswordTextField.isSecureTextEntry
        }
    }
    
    // вернуться к авторизации
    @IBAction func toSignIn(_ sender: Any) {
        let singIpVC = storyboard?.instantiateViewController(withIdentifier: "SingInViewController")
        navigationController?.show(singIpVC!, sender: self)
    }
    
    @IBAction func singup(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let copypassword = copyPasswordTextField.text!
        
        // не давать нажать на кнопку, пока не заполненны поля
        if email.isEmpty || password.isEmpty {
            return
        }
        
        // не давать нажать на кнопку, если не совпадают пароли
        if password != copypassword {
            return
        }
        
        SVProgressHUD.show()
        
        let parameters = ["email": email,
                          "password": password]
        AF.request(Urls.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = "" // чтобы выводить ошибки от сервера. resultString - просто переменная, в которую прелетает responsebody
            
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                // если код 200, мы проверяем дал ли сервер accessToken
                if let token = json["accessToken"].string {
                    
                    let email = json["email"].stringValue // если ничего не прийдет - будет пустая строка (stringValue)
                    
                    Storage.sharedInstance.accessToken = token
                    Storage.sharedInstance.email = email
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    UserDefaults.standard.set(email, forKey: "email")
                    self.startApp()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                // формируем текст для ошибки
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func startApp() {
        let tabViewController = self.storyboard?.instantiateViewController(identifier: "TabBarController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }

}
