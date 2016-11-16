//
//  ViewController.swift
//  meme-me
//
//  Created by Michael Bowerman on 11/14/16.
//  Copyright © 2016 Michael Bowerman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    @IBOutlet var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func incrementCount() {
        self.count = self.count+1
        self.label.text = "\(self.count)"
    }
    func decrementCount() {
        self.count = self.count-1
        self.label.text = "\(self.count)"
    }
    
    func toggleBackgroundColor() {
        self.view.backgroundColor = self.count % 2 != 0 ? UIColor.black : UIColor.white
    }

}

