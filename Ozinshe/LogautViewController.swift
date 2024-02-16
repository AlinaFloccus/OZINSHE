//
//  LogautViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 26.11.2023.
//

import UIKit

class LogautViewController: UIViewController, UIGestureRecognizerDelegate {

   
    @IBOutlet weak var backgroundView: UIView!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true  // все что находится внутри view обрезается - чтобы не торчать за рамки
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // маска - применяется только на верхние края
        
        // чтобы распознать, нажатание на экран
         let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
         tap.delegate = self  //
         view.addGestureRecognizer(tap)
        
        // не знаю для чего
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    // dismiss - закрыть модалку
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // PanGestureRecognizer - следит за движением пальцев
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            case .ended:
                if viewTranslation.y < 100 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.backgroundView.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
        }
    }
    
    // * метод делегата. делегат экрана (нужно ли принимать это за клик) клик по черной области
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backgroundView))! {
            return false
        }
        return true
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "SingInViewController") as! UINavigationController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismissView()
    }
    
}
