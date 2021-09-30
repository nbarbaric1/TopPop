//
//  ViewController.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    private var topTracks: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkController.getTop(number: 10) { error, dataResponse in
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "An error occured.", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            if let dataResponse = dataResponse {
                DispatchQueue.main.async {
                    self.topTracks = dataResponse.data
//                    self.repositorysTableView.reloadData()
                }
            }
        }
    }
}


