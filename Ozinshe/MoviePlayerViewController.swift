//
//  MoviePlayerViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 09.04.2024.
//

import UIKit
import YouTubePlayer

class MoviePlayerViewController: UIViewController {

    @IBOutlet weak var player: YouTubePlayerView!
    
    var video_link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        player.playerVars = [
                            "playsinline": "0",
                            "controls": "1",
                            "showinfo": "0",
                            "rel": "0",
                            "modestbranding": "1",
                            "autohide": "1"
                            ] as YouTubePlayerView.YouTubePlayerParameters
        
        player.loadVideoID(video_link)
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
