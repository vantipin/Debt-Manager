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
@property (weak, nonatomic) IBOutlet UILabel *recommendedLabel;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIButton *amountButton;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIImageView *userPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *debttypeButton;

@property (weak, nonatomic) IBOutlet UITextView *borrowTextView;
@property (weak, nonatomic) IBOutlet UIButton *descrButton;


@property (nonatomic, assign) BOOL debtMode;
@property (nonatomic, assign) BOOL showContactsOnViewWillAppear;

- (IBAction)descrButtonPressed:(id)sender;
- (IBAction)amountButtonPressed:(id)sender;
- (IBAction)currencyPressed:(id)sender;
- (IBAction)datePressed:(id)sender;
- (IBAction)contactNamePressed:(id)sender;
- (IBAction)addBorrowPressed:(id)sender;
- (IBAction)debtTypePressed:(id)sender;


@end
