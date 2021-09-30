//
//  ViewController.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tracksTableView: UITableView!
    @IBOutlet private weak var optionsMenuContainerView: UIView!
    @IBOutlet private weak var optionsMenuContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var optionsMenuButton: UIButton!
    @IBOutlet private weak var normalSortButton: UIButton!
    @IBOutlet private weak var ascSortButton: UIButton!
    @IBOutlet private weak var descSortButton: UIButton!
    
    
    
    // MARK: Properties
    private var topTracks: [Track] = []
    private var isOptionsMenuExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkController.getTop(number: 150) { error, dataResponse in
            
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
                    self.tracksTableView.reloadData()
                }
            }
        }
    }
}

extension HomeViewController {
    @IBAction func optionsMenuButtonActionHandler() {
        if isOptionsMenuExpanded {
            shrinkOptionsMenu()
        }
        else {
            expandOptionsMenu()
        }
    }

}

private extension HomeViewController {
    func navigateToDetailsScreen(for track: Track){
        let nextScreen = "Details"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! DetailsViewController
        nextViewController.track = track
        navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    func shrinkOptionsMenu() {
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction){
            self.optionsMenuContainerViewHeightConstraint.constant = 50
            self.normalSortButton.isHidden = true
            self.ascSortButton.isHidden = true
            self.descSortButton.isHidden = true
            self.isOptionsMenuExpanded = false
            self.view.layoutIfNeeded()
        }
    }
    
    func expandOptionsMenu() {
        UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction){
            self.optionsMenuContainerViewHeightConstraint.constant = 200
            self.normalSortButton.isHidden = false
            self.ascSortButton.isHidden = false
            self.descSortButton.isHidden = false
            self.isOptionsMenuExpanded = true
        self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackTableViewCell.self), for: indexPath) as! TrackTableViewCell
        cell.configureCell(with: topTracks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("sad")
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigateToDetailsScreen(for: topTracks[indexPath.row])
    }
}

