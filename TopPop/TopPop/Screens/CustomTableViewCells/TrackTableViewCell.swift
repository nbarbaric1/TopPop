//
//  TrackTableViewCell.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var trackDurationLabel: UILabel!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var trackPositionLabel: UILabel!
    
    func configureCell(with track: Track) {
        trackNameLabel.text = track.title
        trackDurationLabel.text = String(track.duration)
        artistNameLabel.text = track.artist.name
        trackPositionLabel.text = String(track.position)
    }

}
