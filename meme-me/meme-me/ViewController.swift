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
    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Label
        self.label = UILabel()
        self.label.frame = CGRect.init(x: 150, y: 150, width: 60, height: 60)
        self.label.text = "0"
        self.view.addSubview(self.label)
        
        // Increment Button
        var incrButton = UIButton()
        incrButton.frame = CGRect.init(x: 150, y: 250, width: 60, height: 60)
        incrButton.setTitle("Click (++)", for: .normal)
        incrButton.setTitleColor(UIColor.blue, for: .normal)
        incrButton.addTarget(self, action: #selector(incrementCount), for: UIControlEvents.touchUpInside)
        incrButton.addTarget(self, action: #selector(toggleBackgroundColor), for: UIControlEvents.touchUpInside)
        self.view.addSubview(incrButton)
        
        // Decrement Button
        var decrButton = UIButton()
        decrButton.frame = CGRect.init(x: 250, y: 250, width: 60, height: 60)
        decrButton.setTitle("Click (--)", for: .normal)
        decrButton.setTitleColor(UIColor.blue, for: .normal)
        decrButton.addTarget(self, action: #selector(decrementCount), for: UIControlEvents.touchUpInside)
        decrButton.addTarget(self, action: #selector(toggleBackgroundColor), for: UIControlEvents.touchUpInside)
        self.view.addSubview(decrButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func incrementCount() {
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

