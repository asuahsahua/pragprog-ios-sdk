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
    var player: AVPlayer?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var timeLabel: UILabel!

    // Observer for the player's timer
    private var playerPeriodicObserver: Any?
    
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

        let interval = CMTime(seconds: 0.25, preferredTimescale: 1000)
        playerPeriodicObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: nil) {
            [weak self] currentTime in self?.updateTimeLabel(currentTime)
        }
    }

    func updateTimeLabel(_ time: CMTime) {
        let formatter = DateComponentsFormatter()

        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad

        timeLabel.text = formatter.string(from: TimeInterval(time.seconds))
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

    deinit {
        player?.removeObserver(self, forKeyPath: "rate")

        if let observer = playerPeriodicObserver {
            player?.removeTimeObserver(observer)
        }
    }
}

