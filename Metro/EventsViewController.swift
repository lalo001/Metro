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
    
    override func loadView() {
        super.loadView()
        
        self.title = NSLocalizedString("events", comment: "")
        self.navigationItem.title = self.title?.uppercased()
        self.view.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Create tableView
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Tools.colorPicker(2, alpha: 1)
        
        // Add a backgroundView for color above the search bar.
        let backgroundView = UIView()
        backgroundView.backgroundColor = Tools.colorPicker(2, alpha: 1)
        tableView.backgroundView = backgroundView
        
        tableView.delegate = self
        tableView.dataSource = self
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
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.barStyle = .black
        searchController?.searchBar.delegate = self
        searchController?.searchBar.backgroundColor = Tools.colorPicker(19, alpha: 1)
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
    
    // MARK: - UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Cell")
    }
    
    // MARK: - UITableViewDataSource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataTools.storedEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        cell.textLabel?.text = CoreDataTools.storedEvents?[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }

    // MARK: - UISearchBarDelegate Functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.scopeButtonTitles = [NSLocalizedString("category", comment: ""), NSLocalizedString("date", comment: ""), NSLocalizedString("line", comment: ""), NSLocalizedString("station", comment: "")]
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
