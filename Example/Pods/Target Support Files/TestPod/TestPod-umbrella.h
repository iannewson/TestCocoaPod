#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BridgingHeader.h"
#import "Database.h"
#import "Expression.h"
#import "SqlHelper.h"
#import "sqlite3ext.h"

FOUNDATION_EXPORT double TestPodVersionNumber;
FOUNDATION_EXPORT const unsigned char TestPodVersionString[];

