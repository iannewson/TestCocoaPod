//
//  Database.h
//  TestProject2
//
//  Created by Ian Newson on 29/02/2012.
//  Copyright (c) 2012 Xibis Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sqlite3/sqlite3.h>

@interface Database : NSObject

@property (nonatomic) sqlite3 *database;

+(Database*) instance;

- (sqlite3*) database;
- (NSString*) databasePath;
- (NSNumber*) queryForInt:(NSString*) sql;

- (void) prepareStatement:(NSString*)sql statement:(sqlite3_stmt**)statement;
- (void) withStatementFromSql:(NSString*)sql callback:(void (^)(sqlite3_stmt* statement))callback;
- (void) executeSql:(NSString*)sql;
- (int) getUserVersion;
- (void) setUserVersion:(int)newVersion;
- (void) close;
- (int) lastInsertedRowId;

- (void) beginTransaction;
- (void) commitTransaction;
- (void) rollbackTransaction;

- (NSString*) lastErrorMessage;

- (void) printTableNames;

@end
