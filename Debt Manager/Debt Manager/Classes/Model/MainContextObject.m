//
//  ViewControllerWithCoreDataMethods.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import "MainContextObject.h"

static MainContextObject *instance = nil;

@interface MainContextObject ()

@end

@implementation MainContextObject

@synthesize context = thisManagedObjectContext;
@synthesize model = thisManagedObjectModel;
@synthesize coordinator = thisPersistentStoreCoordinator;

+ (MainContextObject *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (!instance) {
            instance = [[MainContextObject alloc] init];
            //atexit(deallocSingleton);
        }
    });
    
    return instance;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)context
{
    if (thisManagedObjectContext == nil) {
        thisManagedObjectContext = [MainContextObject newManagedObjectContextWithPersistantStoreCoordinator:self.coordinator];
    }
    
    return thisManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)model
{
    if (thisManagedObjectModel == nil) {
        thisManagedObjectModel = [MainContextObject newManagedObjectModel];
    }
    return thisManagedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)coordinator
{
    if (thisPersistentStoreCoordinator == nil) {
        thisPersistentStoreCoordinator = [MainContextObject newPersistentStoreCoordinatorWithModel:[self model]];
    }
    
    return thisPersistentStoreCoordinator;
}

#pragma mark - Core Data manage methods
+ (NSManagedObjectContext *)newManagedObjectContextWithPersistantStoreCoordinator:(NSPersistentStoreCoordinator *)persistentCoordinator
{
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *coordinator = persistentCoordinator;
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

+ (NSManagedObjectModel *)newManagedObjectModel
{
    NSManagedObjectModel *managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Debt_Manager" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithModel:(NSManagedObjectModel *)managedObjectModel
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSURL *storeURL = [[MainContextObject applicationDocumentsDirectory] URLByAppendingPathComponent:@"Debt_Manager.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error Here are include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, tHere are is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
