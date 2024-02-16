//
//  ProfileViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 09.11.2023.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageDelegate {
    
    @IBOutlet weak var myProfileLabal: UILabel!
 
// настройки профиля
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    
//язык
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureViews()
    }
    
    func configureViews() {
        myProfileLabal.text = "MY_PROFILE".localized()
        languageButton.setTitle("LANGUAGE".localized(), for: .normal )
        profileButton.setTitle("PERSONAL DATA".localized(), for: .normal)
        passwordButton.setTitle("CHANGE PASSWORD".localized(), for: .normal)
        notificationButton.setTitle("NOTIFICATION".localized(), for: .normal)
        
        if Localize.currentLanguage() == "ru" {
            languageLabel.text = "Русский"
        }
        if Localize.currentLanguage() == "kk" {
            languageLabel.text = "Қазақша"
        }
        if Localize.currentLanguage() == "en" {
            languageLabel.text = "English"
        }
    }
    
    
    // перейти на страницу "смена языка"
    @IBAction func languageShow(_ sender: Any) {
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        
        languageVC.modalPresentationStyle = .overFullScreen
        languageVC.delegate = self
        
        present(languageVC, animated: true, completion: nil)
        
    }
    
    func languageDidSelected() {
        configureViews()
    }
    
    // перейти на страницу "мои данные"
    @IBAction func profileButton(_ sender: Any) {
        let personalVC = storyboard?.instantiateViewController(withIdentifier: "Personal") as! PersonalDataViewController
        
        navigationController?.pushViewController(personalVC, animated: true)
    }
    
    // перейти на страницу смены пароля
    @IBAction func passwordButton(_ sender: Any) {
        let passwordVC = storyboard?.instantiateViewController(withIdentifier: "Password") as! PasswordViewController
        
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    
    // перейти на страницу выхода
    @IBAction func logoutButton(_ sender: Any) {
        let logourVC = storyboard?.instantiateViewController(withIdentifier: "LogautVC") as! LogautViewController
        
        logourVC.modalPresentationStyle = .overFullScreen
        
        present(logourVC, animated: true, completion: nil)
    }
    
}
