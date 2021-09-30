//
//  DetailsViewController.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var transparentView: UIView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var albumNameLabel: UILabel!
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var tracksListLabel: UILabel!
    
    var track: Track?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        // Do any additional setup after loading the view.
    }
}


// MARK: Functions

private extension DetailsViewController {
    func configureUI(){
        guard let track = track else { return }
        
        songNameLabel.text = track.title
        artistNameLabel.text = track.artist.name
        albumNameLabel.text = track.album.title
        //tracksListLabel.text = track.album.tracklist
        
        containerView.makeRoundedTopCorners(withCornerRadius: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
