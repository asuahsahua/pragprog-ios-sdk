//
//  ViewController.swift
//  PragPods
//
//  Created by Natalie Marion on 9/11/17.
//  Copyright © 2017 Natalie Marion. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController {
    public var player: AVPlayer?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "http://traffic.libsyn.com/cocoaconf/CocoaConf001.m4a") {
            set(url: url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePlayPausedTapped(_ sender: Any) {
        if let player = player {
            if player.rate == 0 {
                player.play()
            } else {
                player.pause()
            }
        }
    }

    func set(url: URL) {
        player = AVPlayer(url: url);
        titleLabel.text = url.lastPathComponent
        player?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
    }

    deinit {
        player?.removeObserver(self, forKeyPath: "rate")
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        if keyPath == "rate", let player = object as? AVPlayer {
            playPauseButton.setTitle(player.rate == 0 ? "Play" : "Pause", for: .normal)
        }
    }
}

