//
//  EventsViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 3/28/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var searchController: UISearchController?
    var eventSearchResultsController: EventSearchResultsTableViewController?
    var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("events", comment: "")
        self.navigationItem.title = self.title?.uppercased()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create tableView
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Add a backgroundView for color above the search bar.
        let backgroundView = UIView()
        backgroundView.backgroundColor = Tools.colorPicker(2, alpha: 1)
        tableView.backgroundView = backgroundView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.indicatorStyle = .white
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(EventCellTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(tableView)
        
        // Add tableView Constraints
        let tableViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["tableView" : tableView])
        let tableViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["tableView" : tableView])
        self.view.addConstraints(tableViewHorizontalConstraints)
        self.view.addConstraints(tableViewVerticalConstraints)
        
        // Create eventSearchResultsController
        eventSearchResultsController = EventSearchResultsTableViewController()
        
        // Create searchController
        searchController = UISearchController(searchResultsController: eventSearchResultsController)
        searchController?.searchResultsUpdater = eventSearchResultsController
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.barTintColor = Tools.colorPicker(19, alpha: 1)
        searchController?.searchBar.delegate = self
        searchController?.searchBar.tintColor = Tools.colorPicker(3, alpha: 1)
        searchController?.searchBar.scopeBarBackgroundImage = Tools.imageFromColor(Tools.colorPicker(19, alpha: 1))
        self.definesPresentationContext = true
        tableView.tableHeaderView = searchController?.searchBar
        self.extendedLayoutIncludesOpaqueBars = true
        
        // Create searchTextField
        let searchTextField = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = Tools.colorPicker(1, alpha: 1)
        searchTextField?.keyboardAppearance = .dark
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EventDetailViewController()
        vc.event = CoreDataTools.storedEvents?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataTools.storedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = EventCellTableViewCell(event: CoreDataTools.storedEvents?[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - UISearchBarDelegate Functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.scopeButtonTitles = [NSLocalizedString("category", comment: ""), NSLocalizedString("date", comment: ""), NSLocalizedString("line", comment: ""), NSLocalizedString("station", comment: "")]
    }
    
    // MARK: - Shake Gesture
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // Update events from API.
            MetroBackend.getEvents(completion: {(events, error) -> Void in
                if error != nil && CoreDataTools.storedEvents == nil {
                    CoreDataTools.storedEvents = []
                } else if error == nil {
                    if let events = events {
                        CoreDataTools.createMetroEvents(events: events)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
