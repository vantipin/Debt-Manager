//
//  User.h
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * idUser;
@property (nonatomic, retain) NSNumber * typeAccount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSManagedObject *debt;

@end
