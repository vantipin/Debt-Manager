//
//  DMSettingsControllerViewController.m
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMSettingsController.h"
#import "DataManager.h"

@interface DMSettingsController ()

@end

@implementation DMSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.borrowLimitTextField.text = [[[DataManager sharedInstance] valueForKey:DefaultRecommendedValueBorrow] stringValue];
    self.lendLimitTextField.text = [[[DataManager sharedInstance] valueForKey:DefaultRecommendedValueLend] stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)textFiedDidChange:(UITextField *)textField {
    NSNumber *number = @(textField.text.integerValue);
    if (number) {
        NSString *key = (textField == self.borrowLimitTextField) ? DefaultRecommendedValueBorrow : (textField == self.lendLimitTextField) ? DefaultRecommendedValueLend : nil;
        if (key) {
            [[DataManager sharedInstance] setValue:number forKey:key];
        }
    }
}

@end
