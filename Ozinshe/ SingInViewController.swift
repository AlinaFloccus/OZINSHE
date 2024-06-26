//
//  SingInViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 18.12.2023.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SingInViewController: UIViewController {
    @IBOutlet weak var emailTextField: TexFieldWithPadding!
    @IBOutlet weak var passwordTextField: TexFieldWithPadding!
    
    @IBOutlet weak var signinButton: UIButton!
    
    
    @IBOutlet weak var error: UILabel!
    
    
    @IBOutlet weak var passwordToTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordToErrorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureteViews()
        hideKeyboardWhenTappedAround()
        
    }
    // настройки для элементов интерфейса
    func configureteViews(){
        emailTextField.layer.cornerRadius = 12.0
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        passwordTextField.layer.cornerRadius = 12.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.0).cgColor
        
        signinButton.layer.cornerRadius = 12.0
        
        error.isHidden = true
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
    @IBAction func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func toSingup(_ sender: Any) {
        let singUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        navigationController?.show(singUpVC!, sender: self)
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    @IBAction func singin(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        // не давать нажать на кнопку, пока не заполненны поля
        if email.isEmpty || password.isEmpty {
            return
        }
        
        // неверный формат почты
        if !isValidEmail(email) {
            error.isHidden = false
            passwordToErrorConstraint.priority = .defaultHigh
            passwordToTextFieldConstraint.priority = .defaultLow
        } else {
            error.isHidden = true
            passwordToErrorConstraint.priority = .defaultLow
            passwordToTextFieldConstraint.priority = .defaultHigh
        }
        
        SVProgressHUD.show()
        
        let parameters = ["email": email,
                          "password": password]
        AF.request(Urls.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            // чтобы выводить ошибки от сервера. resultString - просто переменная, в которую прелетает responsebody
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


