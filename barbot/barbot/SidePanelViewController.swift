//
//  SidePanelViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate {
    func settingSelected(setting: Setting)
}

class SidePanelViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var settings: Array<Setting>!
  
  struct TableView {
    struct CellIdentifiers {
      static let SettingCell = "SettingCell"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.reloadData()
  }
  
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.SettingCell, forIndexPath: indexPath) as! SettingCell
    cell.configureForSetting(settings[indexPath.row])
    return cell
  }
  
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  }
  
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var settingButton: UIButton!
  
    func configureForSetting(setting: Setting) {
        settingButton.setTitle(setting.title, forState: UIControlState.Normal)
    }
  
}