//
//  ViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMMainViewController.h"
#import "DMAddDebtViewController.h"

#define AddDebtSeagueId @""

@interface DMMainViewController ()

@end

@implementation DMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:AddDebtSeagueId]) {
        DMAddDebtViewController *addDebtController = [segue destinationViewController];
        addDebtController.showContactsOnViewWillAppear = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
