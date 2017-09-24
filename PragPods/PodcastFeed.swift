//
// Created by Natalie Marion on 9/24/17.
// Copyright (c) 2017 Natalie Marion. All rights reserved.
//

import Foundation

struct PodcastFeed {
    var title: String?
    var link: URL?
    var description: String?
    var iTunesAuthor: String?
    var iTunesImageURL: URL?

    var episodes: [PodcastEpisode] = []
}
