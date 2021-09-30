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
    private var topTracksSortedAsc: [Track] = []
    private var topTracksSortedDesc: [Track] = []
    private var topTracksUnsorted: [Track] = []
    private var sortedBy: SortingOption = .unsorted
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
                    self.topTracksUnsorted = dataResponse.data
                    self.sortData()
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
    
    @IBAction func normalSortButtonActionHandler() {
        sortedBy = .unsorted
        tracksTableView.reloadData()
    }
    
    @IBAction func ascSortButtonActionHandler() {
        sortedBy = .asc
        tracksTableView.reloadData()
    }
    
    @IBAction func descSortButtonActionHandler() {
        sortedBy = .desc
        tracksTableView.reloadData()
    }

}

private extension HomeViewController {
    
    func sortData() {
        topTracksSortedDesc = topTracksUnsorted.sorted(by: { $0.duration > $1.duration })
        topTracksSortedAsc  = topTracksUnsorted.sorted(by: { $0.duration < $1.duration })
    }
    
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
            self.optionsMenuButton.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
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
            self.optionsMenuButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sortedBy {
            
        case .unsorted:
            return topTracksUnsorted.count
        case .asc:
            return topTracksSortedAsc.count
        case .desc:
            return topTracksSortedDesc.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackTableViewCell.self), for: indexPath) as! TrackTableViewCell
        
        switch sortedBy {
            
        case .unsorted:
            cell.configureCell(with: topTracksUnsorted[indexPath.row])
        case .asc:
            cell.configureCell(with: topTracksSortedAsc[indexPath.row])
        case .desc:
            cell.configureCell(with: topTracksSortedDesc[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch sortedBy {
            
        case .unsorted:
            navigateToDetailsScreen(for: topTracksUnsorted[indexPath.row])
        case .asc:
            navigateToDetailsScreen(for: topTracksSortedAsc[indexPath.row])
        case .desc:
            navigateToDetailsScreen(for: topTracksSortedDesc[indexPath.row])
        }
        
    }
}

enum SortingOption: String {
    case unsorted = "unsorted"
    case asc = "ascending"
    case desc = "descending"
}
