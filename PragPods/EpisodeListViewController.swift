//
//  EpisodeLIstViewController.swift
//  PragPods
//
//  Created by Natalie Marion on 9/24/17.
//  Copyright © 2017 Natalie Marion. All rights reserved.
//

import Foundation
import UIKit

class EpisodeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var feeds : [PodcastFeed] = [] {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }

    @IBOutlet var table: UITableView!

    func numberOfSections(in tableView: UITableView) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds[section].episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episode = feeds[indexPath.section].episodes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell

        cell.titleLabel.text = episode.title
        cell.durationLabel.text = episode.iTunesDuration

        cell.artworkImageView.image = nil
        if let url = episode.iTunesImageURL {
            cell.loadingImageURL = url
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) {
                dataMb, responseMb, errorMb in
                if let data = dataMb, url == cell.loadingImageURL {
                    DispatchQueue.main.async {
                        cell.artworkImageView.image = UIImage(data: data)
                    }
                }
            }
            dataTask.resume()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let feed = feeds[section]
        return feed.title
    }
}
