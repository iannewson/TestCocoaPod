//
//  sqlite3ext.c
//  Test
//
//  Created by Ian Newson on 30/11/2016.
//  Copyright © 2016 Ian Newson. All rights reserved.
//

#include <stdio.h>
#include "sqlite3ext.h"

SQLITE_API int sqlite3_config_ian(int op) {
    return sqlite3_config(op);
}
