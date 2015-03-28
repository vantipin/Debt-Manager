//
//  CoreDataClass.h
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import <Foundation/NSString.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (NSStringAdditions)

+(NSString *)uniqueString;

@end