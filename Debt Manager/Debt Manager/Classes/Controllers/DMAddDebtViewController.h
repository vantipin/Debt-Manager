//
//  DMAddDebtViewController.h
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMViewController.h"
#import "Debt.h"

@interface DMAddDebtViewController : DMViewController

@property (nonatomic) Debt *debt;
@property (nonatomic, assign) BOOL debtMode;

@end
