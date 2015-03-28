//
//  DMSettingsControllerViewController.h
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMViewController.h"

@interface DMSettingsController : DMViewController <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *borrowLimitTextField;
@property (nonatomic) IBOutlet UITextField *lendLimitTextField;

@end
