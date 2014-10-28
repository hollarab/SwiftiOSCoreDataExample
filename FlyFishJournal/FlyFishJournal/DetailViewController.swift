//
//  DetailViewController.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/27/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: ABHEntry? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let entry:ABHEntry = self.detailItem {
            if let label = self.detailDescriptionLabel {
                
                // NOTE - don't move formatters into NSManagedObjects.  ViewControllers own those, so they may be reused.
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd"
                var str = dateFormatter.stringFromDate(entry.timeStamp!)
                
                if let title = entry.title {
                    str += " \(title)"
                }
                
                if let text = entry.text {
                    str += " \(text)"
                }
                
                if let rating = entry.rating {
                    str += " \(rating.integerValue)"
                }
                
                label.text = str
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

