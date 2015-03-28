//
//  CoreDataClass.h
//  BookShelf
//
//  Created by Vlad Antipin on 09.12.13.
//  Copyright (c) 2013 VolcanoSoft. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSStringAdditions.h"
#import "MainContextObject.h"
#import "Debt.h"
#import "User.h"
#import "Constants.h"

@interface DataManager : NSManagedObject

@property (nonatomic) NSManagedObjectContext *context;

+(DataManager *)sharedInstance;

+ (UIImage *)imageForID:(NSString *)anId;
+ (void)saveImage:(UIImage *)anImage withId:(NSString *)anId;

- (void)setValue:(NSNumber *)number forKey:(NSString *)key;
- (NSNumber *)valueForKey:(NSString *)key;

- (NSInteger)amountForType:(DebtType)type;

- (NSArray *)fetchDebtsSortingBy:(SortingType)type;
- (NSArray *)fetchDebtsWithType:(DebtType)debtType sortingBy:(SortingType)sortingType isActive:(BOOL)isActive;

- (UIImage *)imageForType:(DebtType)type;

- (NSArray *)fetchRequestForObjectName:(NSString *)objName
                         withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchRequestForObjectName:(NSString *)objName
                         withPredicate:(NSPredicate *)predicate
                     andSortDescriptor:(NSArray *)sortDescriptors;
- (BOOL)save;
- (BOOL)clearEntityForNameWithObjName:(NSString *)name
                        withPredicate:(NSPredicate *)predicate;

+ (NSString *)standartDateFormat:(NSTimeInterval)date;


@end
