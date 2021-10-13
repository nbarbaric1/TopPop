//
//  ViewController.swift
//  TopPop
//
//  Created by Nikola Barbarić on 30.09.2021..
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tracksTableView: UITableView!
    @IBOutlet private weak var optionsMenuContainerView: UIView!
    @IBOutlet private weak var optionsMenuContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var optionsMenuButton: UIButton!
    @IBOutlet private weak var normalSortButton: UIButton!
    @IBOutlet private weak var ascSortButton: UIButton!
    @IBOutlet private weak var descSortButton: UIButton!
    @IBOutlet private weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var topTracksSortedAsc: [Track] = []
    private var topTracksSortedDesc: [Track] = []
    private var topTracksUnsorted: [Track] = []
    private var offset: Int = 0
    private var sortedBy: SortingOption = .unsorted
    private var isOptionsMenuExpanded = false
    private let refreshControl = UIRefreshControl()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getTop10(offsetBy: offset)
    }
}

// MARK: - IBActions

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

// MARK: - Functions

private extension HomeViewController {
    
    func getTop10(offsetBy: Int) {
        self.loadingActivityIndicatorView.startAnimating()
        NetworkController.getTop10(offsetBy: offsetBy) { error, dataResponse in
            if let error = error {
                DispatchQueue.main.async {
                    self.loadingActivityIndicatorView.stopAnimating()
                    let alert = UIAlertController(title: "An error occured.", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            if let dataResponse = dataResponse {
                DispatchQueue.main.async {
                    self.topTracksUnsorted.append(contentsOf: dataResponse.data)
                    self.sortData()
                    self.loadingActivityIndicatorView.stopAnimating()
                    self.tracksTableView.reloadData()
                }
            }
        }
    }
    
    func configureUI() {
        configureTableView()
    }
    
    func configureTableView() {
        tracksTableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        topTracksUnsorted.removeAll()
        topTracksSortedDesc.removeAll()
        topTracksSortedAsc.removeAll()
        offset = 0
        tracksTableView.reloadData()
        getTop10(offsetBy: offset)
        refreshControl.endRefreshing()
    }
    
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

// MARK: - UITableView protocols

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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tracksTableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if offset + 10 < 300 {
                    offset = offset + 10
                    getTop10(offsetBy: offset)
                }
            }
        }
    }
}

// MARK: - Enums

enum SortingOption: String {
    case unsorted = "unsorted"
    case asc = "ascending"
    case desc = "descending"
}
