//
//  ViewController.h
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMViewController.h"

@interface DMMainViewController : DMViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIView *balanceView;
@property (nonatomic) IBOutlet UIView *borrowView;
@property (nonatomic) IBOutlet UIView *lendView;
@property (nonatomic) IBOutlet UILabel *borrowBalanceLabel;
@property (nonatomic) IBOutlet UILabel *lendBalanceLabel;
@property (nonatomic) IBOutlet UIView *splashScreen;

@end

