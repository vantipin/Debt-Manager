//
//  Debt.h
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Debt : NSManagedObject

@property (nonatomic, retain) NSString * idDebt;
@property (nonatomic, retain) NSNumber * typeDebt;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * descriptionDebt;
@property (nonatomic, retain) NSString * typeMoneyDebt;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * isClosed;
@property (nonatomic, retain) NSSet *user;
@end

@interface Debt (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
