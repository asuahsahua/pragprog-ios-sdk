//
//  EpisodeCell.swift
//  PragPods
//
//  Created by Natalie Marion on 9/25/17.
//  Copyright © 2017 Natalie Marion. All rights reserved.
//

import Foundation
import UIKit

class EpisodeCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artworkImageView: UIImageView!
    @IBOutlet var durationLabel: UILabel!

    var loadingImageURL: URL?
}
    
