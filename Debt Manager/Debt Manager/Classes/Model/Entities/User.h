//
//  User.h
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Debt;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * idUser;
@property (nonatomic, retain) NSNumber * typeAccount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSSet *debt;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDebtObject:(Debt *)value;
- (void)removeDebtObject:(Debt *)value;
- (void)addDebt:(NSSet *)values;
- (void)removeDebt:(NSSet *)values;

@end
