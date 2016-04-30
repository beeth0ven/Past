//
//  ViewController+.swift
//  Past
//
//  Created by luojie on 16/4/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class AutoDeselectTableViewController: UITableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}