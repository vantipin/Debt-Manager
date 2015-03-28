//
//  ViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMMainViewController.h"
#import "DMAddDebtViewController.h"
#import "DataManager.h"
#import "DebtCell.h"
#import "User.h"

#define AddDebtSeagueId @"addDebtSeague"

@interface DMMainViewController ()
{
    SortingType sortingType;
}

@property (nonatomic) NSArray * dataSourceDebts;

@end

@implementation DMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sortingType = DATE_TYPE;
        // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataSourceDebts = [[DataManager sharedInstance] fetchDebtsSortingBy:sortingType];
    [self.tableView reloadData];
    if (!self.dataSourceDebts.count) {
        self.splashScreen.hidden = NO;
        self.tableView.hidden = YES;
        self.balanceView.hidden = YES;
    }
    else {
        self.splashScreen.hidden = YES;
        self.tableView.hidden = NO;
        self.balanceView.hidden = NO;
        
        //configure balance view
        NSInteger maxBorrowed = [[DataManager sharedInstance] valueForKey:DefaultRecommendedValueBorrow].intValue;
        NSInteger maxLent = [[DataManager sharedInstance] valueForKey:DefaultRecommendedValueLend].intValue;
        
        NSInteger currentBorrowed = [[DataManager sharedInstance] amountForType:BORROW_TYPE];
        NSInteger currentLent     = [[DataManager sharedInstance] amountForType:LEND_TYPE];
        
        self.borrowBalanceLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currentBorrowed ,(long)maxBorrowed];
        self.lendBalanceLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currentLent, (long)maxLent];
        
        if (currentBorrowed > maxBorrowed) {
            self.borrowBalanceLabel.textColor = [UIColor redColor];
        }
        else {
            self.borrowBalanceLabel.textColor = [UIColor grayColor];
        }
        
        if (currentLent > maxLent) {
            self.lendBalanceLabel.textColor = [UIColor redColor];
        }
        else {
            self.lendBalanceLabel.textColor = [UIColor grayColor];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceDebts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"debtCellId" forIndexPath:indexPath];
    
    cell.debt = self.dataSourceDebts[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.dataSourceDebts.count) {
        Debt *debt = self.dataSourceDebts[indexPath.row];
        [self performSegueWithIdentifier:AddDebtSeagueId sender:debt];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DMAddDebtViewController *controller = segue.destinationViewController;
    
    if ([controller isKindOfClass:[DMAddDebtViewController class]]) {
        if (sender && [sender isKindOfClass:[Debt class]]) {
            controller.debt = sender;
        } else {
            controller.showContactsOnViewWillAppear = YES;
        }
    }
}

@end
