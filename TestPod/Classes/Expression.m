//
//  Expression.m
//  TestProject2
//
//  Created by Ian Newson on 01/03/2012.
//  Copyright (c) 2012 Xibis Ltd. All rights reserved.
//

#import "Expression.h"

@implementation Expression

-(void) writeSql:(NSMutableString*)sql {
    [NSException raise:@"InvalidOperationException" format:@"You must overide writeSql when inheriting from Expression"];
}

@end
