

import UIKit
import ViewAnimator

class SpotTVC: UITableViewController {
    
    private var spots: [Spot]?
    private let spotCellHeight = UIScreen.main.bounds.width / 5 * 3.5
    
    private let streetCellIdentifier = "StreetTVCell"
    private let activityCellIdentifier = "ActivityTVCell"
    private let emptyCellIdentifier = "EmptyTVCell"
    
    private lazy var profileButton: ProfileButton! = {
        let button = ProfileButton(type: .custom)
        button.setRounded()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(profileBtnPressed(_:)), for: .touchUpInside)
        button.layer.borderWidth = 0.5
        return button
    } ()
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
        configureNav()
        fetchSpots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureProfileButtonUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileButton.removeFromSuperview()
    }
    
    private func configureTV() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.registerUINibs([streetCellIdentifier, activityCellIdentifier, emptyCellIdentifier])
        tableView.addRefersher(refresher)
    }
    
    private func configureNav() {
        navigationController?.setLargeTitleStyle()
        navigationController?.navigationBar.topItem?.title = ApplicationTitle
    }
    
    private func configureProfileButtonUI() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.addSubview(profileButton)
        profileButton.setConstraints(navigationBar)
        profileButton.setProfileImage()
    }
    
    
    private func fetchSpots() {
        SpotNetworkManager().fetchSpotList() { [weak self] (results, err) in
            guard let safeSelf = self else { return }
            guard let res = results else {
                safeSelf.spots = safeSelf.spots == nil ? [] : safeSelf.spots!
                safeSelf.refresher.perform(#selector(UIRefreshControl.endRefreshing), with:  nil, afterDelay: 0.2)
                safeSelf.tableView.reloadData()
                if let error = err {
                    safeSelf.handleNetworkFailure(err: error)
                }
                return
            }
            safeSelf.spots = res.spots == nil ? [] : res.spots!
            safeSelf.refresher.perform(#selector(UIRefreshControl.endRefreshing), with:  nil, afterDelay: 0.2)
            safeSelf.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showStreetMapVC" {
            if let vc = segue.destination as? StreetMapVC, let param = sender as? StreetSegueParam {
                vc.param = param
            }
        }
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchSpots()
    }
    
    @objc private func profileBtnPressed(_ button: UIBarButtonItem) {
        performSegue(withIdentifier: "showProfileVC", sender: nil)
    }
}

extension SpotTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        guard let spots = spots, spots.count > 0 else { return 1 }
        return spots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let spots = spots else {
            let cell = tableView.dequeueReusableCell(withIdentifier: activityCellIdentifier, for: indexPath) as! ActivityTVCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        if spots.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! EmptyTVCell
            cell.descLabel.text = Reachability.isConnectedToNetwork() ? SpotEmptyMessage : NetworkMessage
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: streetCellIdentifier, for: indexPath) as! StreetTVCell
            cell.tag = indexPath.row
            cell.delegate = self
            cell.spot = spots[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard spots != nil, spots!.count > 0 else { return tableView.frame.size.height }
        return spotCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? StreetTVCell, let spot = spots?[indexPath.row] else { return }
        
        let param = StreetSegueParam(spot: spot, categoryIdx: 0)
        performSegue(withIdentifier: "showStreetMapVC", sender: param)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        profileButton.resizeButton(height)
    }
}

extension SpotTVC: StreetTVCellProtocol {
    
    func didSelectCategory(spotIdx: Int, categoryIdx: Int?) {
        guard let spot = spots?[spotIdx] else { return }
        
        let param = StreetSegueParam(spot: spot, categoryIdx: categoryIdx ?? 0)
        performSegue(withIdentifier: "showStreetMapVC", sender: param)
    }
}

