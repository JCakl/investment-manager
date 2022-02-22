//
//  ViewController.swift
//  Investment tool
//
//  Created by Jan Cakl on 29.01.2022.
//

import Cocoa

public let kNotification = Notification.Name("kNotification")

class ViewController: NSViewController {
    
    @IBOutlet var tableView: NSTableView!
    let delegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(reactToNotification(_:)), name: kNotification, object: nil)
    }
    
    @objc func reactToNotification(_ sender: Notification) {
        tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return (delegate.publicData.count)
      }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
       var impViewData = delegate.publicData[row]
        if( delegate.publicData[row].isEmpty ){
            impViewData = [  "broker" : "",
                        "ticker" : "",
                             "name": ""
                     ]
        }else{
            impViewData = delegate.publicData[row]
        }

      let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
      cell?.textField?.stringValue = impViewData[tableColumn!.identifier.rawValue]!

      return cell
    }

}

