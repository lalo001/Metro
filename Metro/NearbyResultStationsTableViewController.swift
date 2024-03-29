//
//  NearbyResultStationsTableViewController.swift
//  Metro
//
//  Created by Eduardo Valencia on 5/7/17.
//  Copyright © 2017 Eduardo Valencia. All rights reserved.
//

import UIKit

class NearbyResultStationsTableViewController: UITableViewController {
    
    var filteredStations: [(Station, CGFloat)]?
    var direction: PickerButton.Direction?
    
    override func loadView() {
        super.loadView()
        self.tableView.register(StationTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.backgroundColor = .clear
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.tableView.indicatorStyle = .white
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = filteredStations?.count ?? 0
        return count > 10 ? 10 : count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StationTableViewCell(stationTuple: filteredStations?[indexPath.row])

        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        Store.shared.needsUpdate = true
        Store.shared.direction = direction
        Store.shared.station = filteredStations?[indexPath.row].0
        guard let parentVC = self.parent as? NearbyStationsViewController else {
            return
        }
        parentVC.closeInput()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
