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
#define DefaultDebtDetailsText @"Debt details"
#define DefaultAmountText @"100"

#define BorrowColor [UIColor colorWithRed:240. / 255. green:1. blue:240. / 255. alpha:1.]
#define LendColor [UIColor colorWithRed:1. green:240. / 255. blue:240. / 255. alpha:1.]

#define BorrowType @"borrow"
#define LendType @"lend"
#define RecommendedFormat @"Your recommended amount to %@ %@%li\nYou can configure limits via Settings"

@interface DMAddDebtViewController () <DMContactsDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) BOOL contactsShown;
@property (nonatomic, strong) DMContactsPopoverController *popoverController;
@property (nonatomic, strong) APContact *selectedContact;

@end

@implementation DMAddDebtViewController
@synthesize debtMode;
@synthesize contactsShown;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    debtMode = YES;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd MMM"];
    
    [self.dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self hideControls];
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
    
    [self hidePopover];
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
        
        [self.borrowTypeLabel setText:(debtMode ? @"Borrow" : @"Lend")];
        
        NSString *labelName = debtMode ? @"Add borrow" : @"Add lend";
        [self setTitleName:labelName];
        [self.bottomAddDebtButton setTitle:labelName forState:UIControlStateNormal];
        
        
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
        [self.view endEditing:YES];
        [self.borrowTextView resignFirstResponder];
        [self.amountTextField resignFirstResponder];
        
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
    if (self.contactsShown) {
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
    [self hideControls];
}

- (IBAction)descrButtonPressed:(id)sender
{
    [sender setHidden:YES];
    
    if ([self.borrowTextView.text isEqualToString:DefaultDebtDetailsText]) {
        [self.borrowTextView setText:@""];
    }
    
    [self.borrowTextView becomeFirstResponder];
}

- (IBAction)amountButtonPressed:(id)sender
{
    [sender setHidden:YES];
    
    if ([self.amountTextField.text isEqualToString:DefaultAmountText]) {
        [self.amountTextField setText:@""];
    }
    
    [self.amountTextField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.amountButton setHidden:NO];
    
    if ([self.amountTextField.text isEqualToString:@""]) {
        [self.amountTextField setText:DefaultAmountText];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePopover];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self hidePopover];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.descrButton setHidden:NO];
    
    if ([self.borrowTextView.text isEqualToString:@""]) {
        [self.borrowTextView setText:DefaultDebtDetailsText];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
