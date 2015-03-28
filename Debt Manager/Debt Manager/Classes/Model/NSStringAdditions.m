//
//  CoreDataClass.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import "NSStringAdditions.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation NSString (NSStringAdditions)

+(NSString *)uniqueString;
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    NSString *unique = (__bridge_transfer NSString *)(uuidStr);
    return unique;
}

@end
