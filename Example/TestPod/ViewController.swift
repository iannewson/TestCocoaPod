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
        
        Database.instance().executeSql("CREATE TABLE IF NOT EXISTS Thing (name TEXT)")
        
        Database.instance().printTableNames()
        Database.instance().withStatementFromSql("SELECT name FROM sqlite_master WHERE type ='table'", callback: {statement in
            while SQLITE_ROW == sqlite3_step(statement) {
                print("Column index: \(sqlite3_column_count(statement))")
                let name = SqlHelper.toString(statement, columnName: "name")
                print("Table: \(name)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

