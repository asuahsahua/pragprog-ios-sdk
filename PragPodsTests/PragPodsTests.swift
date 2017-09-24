//
//  PragPodsTests.swift
//  PragPodsTests
//
//  Created by Natalie Marion on 9/11/17.
//  Copyright © 2017 Natalie Marion. All rights reserved.
//

import XCTest
import CoreMedia
@testable import PragPods

class PragPodsTests: XCTestCase {
    var playerVC: ViewController?
    var startedPlayingExpectation: XCTestExpectation?
    var startedPlayingTimer: Timer?

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? ViewController else {
            XCTFail("Couldn't load player scene")
            return
        }

        playerVC.loadViewIfNeeded()

        self.playerVC = playerVC
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPlayerTitleLabel_WhenUrlSet_ShowsCorrectFilename() {
        XCTAssertEqual("CocoaConf001.m4a", playerVC!.titleLabel.text)
    }

    func testPlayerPlayPauseButton_whenPlaying_showsPause() {
        playerVC!.handlePlayPausedTapped(self)

        XCTAssertEqual("Pause", playerVC!.playPauseButton.title(for: .normal))
    }

    func testPlayerCurrentTime_WhenPlaying_IsNotZero() {
        startedPlayingExpectation = expectation(description: "player starts playing when tapped")
        startedPlayingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timedPlaybackChecker), userInfo: nil, repeats: true)

        playerVC!.handlePlayPausedTapped(self)

        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func timedPlaybackChecker(timer: Timer) {
        if let player = playerVC?.player, player.currentTime().seconds > 0 {
            startedPlayingExpectation?.fulfill()
            startedPlayingTimer?.invalidate()
        }
    }
}
