//
//  TrackTableViewCell.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import UIKit
import Kingfisher

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var trackDurationLabel: UILabel!
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var trackPositionLabel: UILabel!
    
    func configureCell(with track: Track) {
        trackNameLabel.text = track.title
        trackDurationLabel.text = formatDuration(input: track.duration)
        artistNameLabel.text = track.artist.name
        trackPositionLabel.text = String(track.position)
        artistImageView.kf.setImage(with: track.artist.pictureMedium, placeholder: UIImage(named: "music.note"))
    }
    
    func formatDuration(input: Int) -> String {
        let minutes:String = input / 60 < 10 ? String("0\(input / 60)") : String(input / 60)
        let seconds: String = input % 60 < 10 ? String("0\(input % 60)") : String(input % 60)
        let output: String = minutes + ":" + seconds
        return output
    }
    
    override func prepareForReuse() {
        trackNameLabel.text = ""
        trackDurationLabel.text = ""
        artistNameLabel.text = ""
        trackPositionLabel.text = ""
        artistImageView.image = nil
        artistImageView.kf.cancelDownloadTask()
    }
}
