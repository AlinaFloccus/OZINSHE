//
//  TabBarController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 22.12.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTabImages()
    }
    
    func setTabImages() {
        let homeselectedimage = UIImage(named: "HomeActive")!.withRenderingMode(.alwaysOriginal)
        
        let searchselectedimage = UIImage(named: "SearchActive")!.withRenderingMode(.alwaysOriginal)
        
        let favoriteselectedimage = UIImage(named: "FavoritesActive")!.withRenderingMode(.alwaysOriginal)
        
        let profileselectedimage = UIImage(named: "ProfileActive")!.withRenderingMode(.alwaysOriginal)
        
        tabBar.items?[0].selectedImage = homeselectedimage
        tabBar.items?[1].selectedImage = searchselectedimage
        tabBar.items?[2].selectedImage = favoriteselectedimage
        tabBar.items?[3].selectedImage = profileselectedimage
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
