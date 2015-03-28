//
//  DMViewController.h
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSString *titleName;

- (IBAction)backPressed:(id)sender;

@end
