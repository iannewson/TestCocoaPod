//
//  SqlHelper.m
//  TestProject2
//
//  Created by Ian Newson on 01/03/2012.
//  Copyright (c) 2012 Xibis Ltd. All rights reserved.
//

#import "SqlHelper.h"

@implementation SqlHelper

+(NSString*) floatToSql:(float)value {
    return [NSString stringWithFormat:@"%.4f", value];
}

+(NSString*) doubleToSql:(double)value {
    return [NSString stringWithFormat:@"%.4f", value];
}

+(NSString*) stringToSql:(NSString*)value {
    if (nil == value) {
        return @"NULL";
    }
    return [NSString stringWithFormat:@"'%@'", [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
}

+(NSString*) intToSql:(int)value {
    return [NSString stringWithFormat:@"%d", value];
}

+(NSString*) boolToSql:(BOOL)value {
    if (YES == value) {
        return [self intToSql:1];
    } else {
        return [self intToSql:0];
    }
}

+(NSString*) boolNumberToSql:(NSNumber*)value {
	if (nil == value) {
		return @"NULL";
	}
	return [SqlHelper boolToSql:[value boolValue]];
}

+(NSString*) dateToSql:(NSDate*)value {
    return [NSString stringWithFormat:@"%f", [value timeIntervalSince1970]];
}

+(NSString*) objectToSql:(NSObject*)value {
    if (nil == value) {
        return @"NULL";
    } else {
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber* numberValue = (NSNumber*)value;
            return [SqlHelper numberToSql:numberValue];
        } else if ([value isKindOfClass:[NSDate class]]) {
            NSDate* date = (NSDate*)value;
            return [SqlHelper dateToSql:date];
        } else if ([value isKindOfClass:[NSArray class]]) {
            BOOL isFirst = YES;
            NSMutableString *str = [NSMutableString new];
            for (NSObject* obj in (NSArray*)value) {
                if (isFirst) {
                    isFirst = false;
                } else {
                    [str appendString:@", "];
                }
                [str appendString:[self objectToSql:obj]];
            }
            return str;
        } else {
            return [SqlHelper stringToSql:[value description]];
        }
    }
}

+(NSString*) numberToSql:(NSNumber*)value {
	if (nil == value) {
		return @"NULL";
	}
    if ([value intValue] == [value floatValue]) {
        return [SqlHelper intToSql:[value intValue]];
    } else{
        return [SqlHelper floatToSql:[value floatValue]];
    }
}

+(NSDate*) toDate:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [SqlHelper toDate:statement columnIndex:[SqlHelper getColumnIndex:statement :columnName]];
}

+(NSDate*) toDate:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    double milliseconds = sqlite3_column_double(statement, columnIndex);
	if (0 == milliseconds) {
		return nil;
	} else {
		return [NSDate dateWithTimeIntervalSince1970:milliseconds];
	}
}

+(NSString*) toString:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [SqlHelper toString:statement columnIndex:[SqlHelper getColumnIndex:statement :columnName]];
}

+(NSString*) toString:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    const unsigned char* result = sqlite3_column_text(statement, columnIndex);
    
    if (result == nil) {
        return nil;
    }
    
    return [NSString stringWithUTF8String: (const char*)result];
}

+(int) toInt:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [SqlHelper toInt:statement columnIndex:[SqlHelper getColumnIndex:statement :columnName]];
}

+(int) toInt:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    return sqlite3_column_int(statement, columnIndex);
}

+(float) toFloat:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [SqlHelper toFloat:statement columnIndex:[SqlHelper getColumnIndex:statement :columnName]];
}

+(float) toFloat:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    return sqlite3_column_double(statement, columnIndex);
}

+(double) toDouble:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [SqlHelper toDouble:statement columnIndex:[SqlHelper getColumnIndex:statement :columnName]];
}

+(double) toDouble:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    return sqlite3_column_double(statement, columnIndex);
}

+(BOOL) toBoolean:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [SqlHelper toBoolean:statement columnIndex:[SqlHelper getColumnIndex:statement :columnName]];
}

+(BOOL) toBoolean:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    if (sqlite3_column_int(statement, columnIndex) == 1) {
        return YES;
    } else {
        return NO;
    }
}

+(NSNumber*) toBooleanNumber:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
	int columnIndex = [SqlHelper getColumnIndex:statement :columnName];
	return [SqlHelper toBooleanNumber:statement columnIndex:columnIndex];
}

+(NSNumber*) toBooleanNumber:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
	if (sqlite3_column_type(statement, columnIndex) == SQLITE_NULL) {
		return nil;
	}
	return [NSNumber numberWithBool:[SqlHelper toBoolean:statement columnIndex:columnIndex]];
}

+(int) getColumnIndex:(sqlite3_stmt*)statement :(NSString*)columnName {
    for (int i = 0; i < sqlite3_column_count(statement); ++i) {
        if ([[NSString stringWithUTF8String:sqlite3_column_name(statement, i)] isEqualToString:columnName]) {
            return i;
        }
    }
    return -1;
}


+(NSData*) toBlob:(sqlite3_stmt*)statement columnName:(NSString*)columnName {
    return [self toBlob:statement columnIndex:[self getColumnIndex:statement :columnName]];
}

+(NSData*) toBlob:(sqlite3_stmt*)statement columnIndex:(int)columnIndex {
    int length = sqlite3_column_bytes(statement, columnIndex);
    return [NSData dataWithBytes:sqlite3_column_blob(statement, columnIndex) length:length];
}


@end
