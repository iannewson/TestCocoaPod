//
//  ViewController.swift
//  TestPod
//
//  Created by Ian Newson on 12/01/2016.
//  Copyright (c) 2016 Ian Newson. All rights reserved.
//

import UIKit
import TestPod

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Test.doDbStuff()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

