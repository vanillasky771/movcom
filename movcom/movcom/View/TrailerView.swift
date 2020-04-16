//
//  TrailerView.swift
//  movcom
//
//  Created by Ivan on 15/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
class TrailerView: UIViewController {

    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoPlayer  : WKWebView!
    var videoKey                    : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Loading video from youtube URL
        loadVideo(key: "https://www.youtube.com/watch?v=\(videoKey!)&autoplay=1")
        
        
        //MARK: - To Manipulate AVPlayerView
        NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeVisibleNotification,
            object: self.view.window,
            queue: nil
        ) { notification in
            self.loadIndicator.stopAnimating()
        }

        NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeHiddenNotification,
            object: self.view.window,
            queue: nil
        ) { notification in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadVideo(key: String){
        let url = URL(string: key)
        videoPlayer.load(URLRequest(url: url!))
    }
    

}
