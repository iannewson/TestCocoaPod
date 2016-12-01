//
//  Database.m
//  TestProject2
//
//  Created by Ian Newson on 29/02/2012.
//  Copyright (c) 2012 Xibis Ltd. All rights reserved.
//

#import "Database.h"

@interface Database (Private)

- (void) upgradeDatabase:(int)fromVersion :(int)toVersion;

@end

@implementation Database
@synthesize database;

static Database* instance = nil;
static int DATABASE_VERSION = 1;
+(Database*) instance {
    if (nil == instance) {
        @synchronized(self) {
            if (nil == instance) {
                instance = [[Database alloc] init];
            }
        }
    }
    return instance;
}

- (sqlite3*) database {
    if (nil == database) {
        
        sqlite3_shutdown();
        
        int retCode = sqlite3_config(SQLITE_CONFIG_SERIALIZED);
        if (retCode == SQLITE_OK) {
            NSLog(@"Can now use sqlite on multiple threads, using the same connection");
        } else {
            NSLog(@"setting sqlite thread safe mode to serialized failed!!! return code: %d", retCode);
        }
        if (sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
            //Check the version against the current version
            if ([self getUserVersion] < DATABASE_VERSION) {
                
            }
        } else {
            [NSException raise:NSInternalInconsistencyException format:@"The database could not be opened. I don't know why."];
        }
    }
    return database;
}

- (void) upgradeDatabase:(int)fromVersion :(int)toVersion {
}

- (void) prepareStatement:(NSString*)sql statement:(sqlite3_stmt**)statement {
    @synchronized (self) {
    int result = sqlite3_prepare_v2([self database], [sql UTF8String], -1, statement, NULL);
    NSString *errorMessage = nil;
    BOOL isError = YES;
    switch (result) {
        case SQLITE_OK:
            isError = NO;
            break;
        case SQLITE_ERROR:
            errorMessage = [self lastErrorMessage];
            break;
        default:
            break;
    }
    if (YES == isError) {
        if (nil == errorMessage) {
            errorMessage = [NSString stringWithFormat:@"Error preparing SQL statement, this may be due to the query, which is '%@'", sql];
        }
        [NSException raise:NSInvalidArgumentException format:errorMessage];
    }
    }
}

- (NSString*) lastErrorMessage {
    return [[NSString alloc] initWithUTF8String:sqlite3_errmsg([self database])];
}

- (void) withStatementFromSql:(NSString*)sql callback:(void (^)(sqlite3_stmt* statement))callback {
    sqlite3_stmt *statement;
    @synchronized (self) {
        
       

        
    [self prepareStatement:sql statement:&statement];
    @try {
    	callback(statement);
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
    	statement = nil;
    	sqlite3_finalize(statement);
	}

    }
}

- (NSNumber*) queryForInt:(NSString*) sql {
    
    __block NSNumber *result;
    
    [self withStatementFromSql:sql callback:^(sqlite3_stmt* statement) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            result = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
        }
    }];
    
    return result;
}

- (void) executeSql:(NSString*)sql {
    [self withStatementFromSql:sql callback:^(sqlite3_stmt* statement) {
        int result = sqlite3_step(statement);
        if (SQLITE_DONE != result) {
            NSString* strErrorMessage = [NSString stringWithFormat:@"Error executing SQL statement. This is probably due to the SQL: '%@'", sql];
            
            if (SQLITE_ERROR == result) {
                strErrorMessage = [strErrorMessage stringByAppendingString:[self lastErrorMessage]];
            }
            
            [NSException raise:NSInvalidArgumentException format:strErrorMessage];
        }
    }];
}

- (int) getUserVersion {
    NSNumber* version = [self queryForInt:@"PRAGMA user_version"];
    if (version) {
        return [version intValue];
    }
    return 0;
}

- (void) setUserVersion:(int)newVersion {
    int currentVersion = [self getUserVersion];
    if (newVersion <= currentVersion) {
        [NSException raise:NSInvalidArgumentException format:@"New version is lower or equal to the current version. New version: %s, old version: %s", newVersion, currentVersion];
    }
    [self executeSql:[NSString stringWithFormat:@"PRAGMA user_version = %d;", newVersion]];
}

- (NSString*) databasePath {
    NSString *userDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [userDirectoryPath stringByAppendingPathComponent:@"database.db"];
}

- (void) close {
    if (nil != database) {
        sqlite3_close(database);
    }
}

- (int) lastInsertedRowId {
	return sqlite3_last_insert_rowid([self database]);
}

- (void) beginTransaction {
    sqlite3_exec([self database], "BEGIN", 0, 0, 0);
}

- (void) commitTransaction {
    sqlite3_exec([self database], "COMMIT", 0, 0, 0);    
}

- (void) rollbackTransaction {
    sqlite3_exec([self database], "ROLLBACK", 0, 0, 0);
}

@end
