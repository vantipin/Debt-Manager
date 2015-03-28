//
//  CoreDataClass.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import "DataManager.h"
#import "NSStringAdditions.h"
#import "MainContextObject.h"
#import <CommonCrypto/CommonHMAC.h>

static DataManager *instance = nil;

@implementation DataManager

@synthesize context = _context;

+ (DataManager *)sharedInstance
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[DataManager alloc] init];
        }
    });
    
    return instance;
}

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [MainContextObject sharedInstance].context;
    }
    
    return _context;
}







- (NSArray *)fetchRequestForObjectName:(NSString *)objName
                         withPredicate:(NSPredicate *)predicate
{
    return [self fetchRequestForObjectName:objName withPredicate:predicate andSortDescriptor:nil];
}

- (NSArray *)fetchRequestForObjectName:(NSString *)objName
                         withPredicate:(NSPredicate *)predicate
                     andSortDescriptor:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [NSFetchRequest new];
    request.entity = [NSEntityDescription entityForName:objName inManagedObjectContext:self.context];
    request.predicate = predicate;
    
    if (sortDescriptors != nil && sortDescriptors.count) {
        request.sortDescriptors = sortDescriptors;
    }
    
    NSError *error = nil;
    NSArray *objPool = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        return objPool;
    }
    
    return nil;
}

- (BOOL)save
{
    NSError *error = nil;
    if ([self.context hasChanges]) {
        if (![self.context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            
            return false;
        }
        else {
            //save succeed
            
        }
    }
    else {
        NSLog(@"Context hasn't changed");
    }
    
    return true;
}

- (BOOL)clearEntityForNameWithObjName:(NSString *)name
                        withPredicate:(NSPredicate *)predicate
{
    
    NSArray *objectsPool = [self fetchRequestForObjectName:name withPredicate:predicate];
    
    if (objectsPool.count > 0 ) {
        for (id obj in objectsPool) {
            [self.context deleteObject:obj];
        }
        [self save];
        return true;
        
    }
    return false;
}


+ (NSString *)standartDateFormat:(NSTimeInterval)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    
    return dateString;
}
@end
