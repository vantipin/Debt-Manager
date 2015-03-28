//
//  DMAddDebtViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMAddDebtViewController.h"

#import "APContact.h"
#import "DataManager.h"
#import "DMContactsPopoverController.h"

#define DefaultRecommendedValue @"DefaultRecommendedValue"
#define ContactPopoverId @"ContactCollectionPopoverID"

#define BorrowColor [UIColor colorWithRed:240. / 255. green:1. blue:240. / 255. alpha:1.]
#define LendColor [UIColor colorWithRed:1. green:240. / 255. blue:240. / 255. alpha:1.]

#define BorrowType @"borrow"
#define LendType @"lend"
#define RecommendedFormat @"Your recommended amount to %@ %@%li\nYou can configure limits via Settings"

@interface DMAddDebtViewController () <DMContactsDelegate>

@property (nonatomic, assign) BOOL contactsShown;
@property (nonatomic, strong) DMContactsPopoverController *popoverController;

@end

@implementation DMAddDebtViewController
@synthesize debtMode;
@synthesize contactsShown;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (self.showContactsOnViewWillAppear) {
//        
//    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.showContactsOnViewWillAppear) {
        self.showContactsOnViewWillAppear = NO;
        [self contactNamePressed:nil];
    }
}

- (void)hideControls
{
    [self.view endEditing:YES];
    [self.borrowTextView resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    
    
}

- (void)setDebtMode:(BOOL)aDebtMode
{
    if (aDebtMode != debtMode) {
        debtMode = aDebtMode;
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        id objectForKey = [standardUserDefaults objectForKey:DefaultRecommendedValue];
        
        NSInteger recommendedValue = objectForKey ? [objectForKey integerValue] : 300;
        
        [self.recommendedLabel setText:[NSString stringWithFormat:RecommendedFormat, debtMode ? BorrowType : LendType, [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol], (long)recommendedValue]];
        
        [self.debttypeButton setImage:[UIImage imageNamed:debtMode ? @"borrowIcon@2x.png" : @"lendIcon@2x.png"] forState:UIControlStateNormal];
        
        [self.view setBackgroundColor:(debtMode ? BorrowColor : LendColor)];
        
        if (debtMode) {
            
        }
    }
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

- (IBAction)currencyPressed:(id)sender
{
    
}

- (IBAction)datePressed:(id)sender
{
    
}

- (IBAction)contactNamePressed:(id)sender
{
    if (!self.contactsShown) {
        self.contactsShown = YES;
        popoverController = [self.storyboard instantiateViewControllerWithIdentifier:ContactPopoverId];
        popoverController.contactDelegate = self;
        
        CGRect startFrame = popoverController.view.frame;
        startFrame.size.height = 276.;
        startFrame.origin.y = self.view.frame.size.height;
        CGRect finalFrame = startFrame;
        finalFrame.origin.y -= finalFrame.size.height;
        popoverController.view.frame = startFrame;
        [self.view addSubview:popoverController.view];
        
        [UIView animateWithDuration:sender ? 0.3 : 0. animations:^{
            [popoverController.view setFrame:finalFrame];
        }];
    } else {
        [self addPhoto];
    }
}

- (void)addPhoto
{
    
}

#pragma mark - Contact delegate methods

- (void)hidePopover
{
    self.contactsShown = NO;
    
    CGRect finalFrame = popoverController.view.frame;
    finalFrame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [popoverController.view setFrame:finalFrame];
    } completion:^(BOOL finished) {
        [self.popoverController.view removeFromSuperview];
        self.popoverController = nil;
    }];
}

- (void)donePressedForContacts
{
    [self hidePopover];
}

- (void)contactSelected:(APContact *)contact
{
    NSString *firstName = contact.firstName && [contact.firstName class] != [NSNull class] ? contact.firstName : @"";
    NSString *lastName = contact.lastName && [contact.lastName class] != [NSNull class] ? contact.lastName : @"";
    
    [self.nameLabel setText:[NSString stringWithFormat:@"%@%@", (firstName.length ? [NSString stringWithFormat:@"%@ ", firstName] : @""), lastName]];
    
    if (contact.thumbnail) {
        [self.userPicImageView setImage:contact.thumbnail];
    } else {
        [self.userPicImageView setImage:[UIImage imageNamed:@"userPicLargePlaceholder.png"]];
    }
    
    [self hidePopover];
}

- (IBAction)addBorrowPressed:(id)sender
{
    
}

- (IBAction)debtTypePressed:(id)sender
{
    self.debtMode = !debtMode;
}

@end
