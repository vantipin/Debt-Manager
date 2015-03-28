//
//  Constants.h
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.


#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]

typedef enum {
    BORROW_TYPE = 0,
    LEND_TYPE = 1
} DebtType;

typedef enum {
    CONTACTS_TYPE = 0,
    FACEBOOK_TYPE = 1,
    TWITTER_TYPE = 2
} AccountType;