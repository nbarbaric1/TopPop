//
//  DetailsViewController.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//
import Kingfisher
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var transparentView: UIView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var albumNameLabel: UILabel!
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var tracksListLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var track: Track?
    var tracklist: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let track = track else { return }
        configureUI()
        getTracklist(for: track.album.id)
    }
}


// MARK: Functions

private extension DetailsViewController {
    
    func getTracklist(for id: Int) {
        NetworkController.getTracklist(for: id) { error, dataResponse in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "An error occured.", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            if let dataResponse = dataResponse {
                
                DispatchQueue.main.async {
                    dataResponse.data.forEach { track2 in
                        let t = track2.title
                        self.tracklist.append(contentsOf: "\(t)\n")
                    }
                    self.tracksListLabel.text = self.tracklist
                  
                }
            }
        }
    }
    
    func configureUI(){
        guard let track = track else { return }
        
        songNameLabel.text = track.title
        artistNameLabel.text = track.artist.name
        albumNameLabel.text = track.album.title
        albumImageView.kf.setImage(with: track.album.coverMedium, placeholder: UIImage(named: "music.note.house"))
        
        //tracksListLabel.text = track.album.tracklist
        
        containerView.makeRoundedTopCorners(withCornerRadius: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        transparentView.addGestureRecognizer(tapGesture)
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: tracksListLabel.bottomAnchor).isActive = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
