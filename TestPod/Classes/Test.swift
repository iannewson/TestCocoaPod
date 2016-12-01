//
//  Test.swift
//  Pods
//
//  Created by Ian Newson on 01/12/2016.
//
//

import Foundation
import sqlite3

public class Test {
    
    public static func doDbStuff() {
        do {
            
            var db :OpaquePointer?
            let dbPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("\(Date.init().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "") + ".db")
                .path
            
            var returnCode :Int32 = sqlite3_open(dbPath, &db)
            if SQLITE_OK != returnCode {
                preconditionFailure("Failed to open db")
            }
            
            var stmt :OpaquePointer?
            returnCode = sqlite3_prepare_v2(db, "CREATE TABLE Things (name TEXT)", -1, &stmt, nil)
            if SQLITE_OK != returnCode {
                preconditionFailure("Failed to prepare table creation SQL")
            }
            returnCode = sqlite3_step(stmt)
            if SQLITE_DONE != returnCode {
                preconditionFailure("Failed to execute tbl creation SQL")
            }
            returnCode = sqlite3_prepare_v2(db, "SELECT name FROM sqlite_master WHERE type ='table'", -1, &stmt, nil)
            if SQLITE_OK != returnCode {
                preconditionFailure("Failed to prepare count SQL")
            }
            returnCode = sqlite3_step(stmt)
            if SQLITE_ROW != returnCode {
                preconditionFailure("Failed to execute count SQL")
            } else {
                let columnCount = sqlite3_column_count(stmt)
                print("columnCount: \(columnCount)")
                let name = String(cString: sqlite3_column_text(stmt, 0))
                //print("Num tables: \(count)")
                print("Table name: \(name)")
            }
            
        } catch let error {
            preconditionFailure(error.localizedDescription)
        }
    }
    
}
