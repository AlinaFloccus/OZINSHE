//
//  LanguageViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 12.11.2023.
//

import UIKit
import Localize_Swift

protocol LanguageDelegate {
    func languageDidSelected()
}

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    
    var delegate: LanguageDelegate?
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    let languageArray = [["English", "en"], ["Қазақша", "kk"], ["Русский", "ru"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self

        
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true  // все что находится внутри view обрезается - чтобы не торчать за рамки
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // маска - применяется только на верхние края
        
       // чтобы распознать, нажатание на экран
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    // dismiss - закрыть модалку
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // делегат экрана (нужно ли принимать это за клик) клик по черной области
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backgroundView))! {
            return false
        }
        return true
    }
    
    // отрисовка строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(100) as! UILabel
        label.text = languageArray[indexPath.row][0]
        
        let checkImageView = cell.viewWithTag(101) as! UIImageView
        
        if Localize.currentLanguage() == languageArray[indexPath.row][1] {
            checkImageView.image = UIImage(named: "Check")
        } else {
            checkImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
  //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Localize.setCurrentLanguage(languageArray[indexPath.row][1])
        
        delegate?.languageDidSelected()
        
        dismiss(animated: true, completion: nil)
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
