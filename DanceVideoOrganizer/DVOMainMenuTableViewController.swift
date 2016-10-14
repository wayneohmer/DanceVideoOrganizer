//
//  DVOMainMenuTableViewController.swift
//  DanceVideoOrganizer
//
//  Created by Wayne Ohmer on 5/26/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class DVOMainMenuTableViewController: UITableViewController {

    struct MenuItem {
        var title = ""
        var storyboardId = ""
    }
    
    let mainStoryboard = UIStoryboard(name:"Main", bundle: nil)
    var menu = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menu.append(MenuItem(title: "Browse Local Videos", storyboardId: "DVOSelectVideoTableViewController"))
        self.menu.append(MenuItem(title: "Browse MetaData", storyboardId: "DVOMetaDataTableViewController"))
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

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
        return self.menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        
        cell.itemNameLabel.text = self.menu[(indexPath as NSIndexPath).item].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: self.menu[(indexPath as NSIndexPath).item].storyboardId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
}

