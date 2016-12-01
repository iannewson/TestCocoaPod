//
//  SqlHelper.h
//  TestProject2
//
//  Created by Ian Newson on 01/03/2012.
//  Copyright (c) 2012 Xibis Ltd. All rights reserved.
//

#import "Expression.h"
#import <Sqlite3/sqlite3.h>

@interface SqlHelper : Expression

+(NSString*) floatToSql:(float)value;
+(NSString*) doubleToSql:(double)value;
+(NSString*) stringToSql:(NSString*)value;
+(NSString*) intToSql:(int)value;
+(NSString*) boolToSql:(BOOL)value;
+(NSString*) boolNumberToSql:(NSNumber*)value;
+(NSString*) dateToSql:(NSDate*)value;
+(NSString*) objectToSql:(NSObject*)value;

+(NSString*) numberToSql:(NSNumber*)value;

+(BOOL) toBoolean:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(BOOL) toBoolean:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(NSData*) toBlob:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(NSData*) toBlob:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(NSNumber*) toBooleanNumber:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(NSNumber*) toBooleanNumber:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(NSDate*) toDate:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(NSDate*) toDate:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(NSString*) toString:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(NSString*) toString:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(int) toInt:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(int) toInt:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(float) toFloat:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(float) toFloat:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(double) toDouble:(sqlite3_stmt*)statement columnName:(NSString*)columnName;
+(double) toDouble:(sqlite3_stmt*)statement columnIndex:(int)columnIndex;

+(int) getColumnIndex:(sqlite3_stmt*)statement :(NSString*)columnIndex;

@end
