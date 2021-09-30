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
        containerView.makeRoundedTopCorners(withCornerRadius: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
