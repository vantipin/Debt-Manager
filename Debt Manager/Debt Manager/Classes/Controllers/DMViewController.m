//
//  DMViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMViewController.h"

@interface DMViewController ()

@end

@implementation DMViewController

- (void)setTitleName:(NSString *)titleName
{
    [self.titleLabel setText:titleName];
}

- (void)backPressed:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
