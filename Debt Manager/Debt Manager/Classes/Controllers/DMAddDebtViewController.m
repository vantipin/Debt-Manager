//
//  DMAddDebtViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMAddDebtViewController.h"
#import "NSManagedObject+Queries.h"
#import "User.h"
#import "Debt.h"

#import "APContact.h"
#import "DataManager.h"
#import "DMContactsPopoverController.h"
#import <MessageUI/MessageUI.h>

#define DefaultRecommendedValue @"DefaultRecommendedValue"
#define ContactPopoverId @"ContactCollectionPopoverID"
#define DefaultDebtDetailsText @"Debt details"
#define DefaultAmountText @"100"

#define BorrowColor [UIColor colorWithRed:240. / 255. green:240. / 255. blue:240. / 255. alpha:1.]
#define LendColor [UIColor colorWithRed:240. / 255. green:240. / 255. blue:240. / 255. alpha:1.]

#define BorrowType @"borrow"
#define LendType @"lend"
#define RecommendedFormat @"Your recommended amount to %@ %@%li\nYou can configure limits via Settings"

@interface DMAddDebtViewController () <DMContactsDelegate, UITextFieldDelegate, UITextViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    float keyBoardY;
    float currentViewYMargin;
}
@property (nonatomic, assign) BOOL contactsShown;
@property (nonatomic, strong) DMContactsPopoverController *popoverController;
@property (nonatomic, strong) APContact *selectedContact;
@property (nonatomic, strong) UIAlertView *alert;

@end

@implementation DMAddDebtViewController
@synthesize debtMode;
@synthesize contactsShown;
@synthesize popoverController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.showContactsOnViewWillAppear) {
        debtMode = YES;
        
        for (UIButton *button in self.addDebtButtons) {
            [button setEnabled:NO];
        }
    }
    
    keyBoardY = 0.0;
    currentViewYMargin = 0.0;

    
    [self configureCurrentRecommendedValue];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"dd MMM"];
    
    [self.dateButton setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    
    if (self.debt) {
        for (UIView *view in self.unusedDetailsControls) {
            [view setUserInteractionEnabled:NO];
        }
        
        for (UIView *view in self.hidableControls) {
            [view setHidden:YES];
        }
        
        for (UIView *view in self.detailsControls) {
            [view setHidden:NO];
        }
        
        [self setDebtMode:([self.debt.typeDebt integerValue] == BORROW_TYPE) force:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self hideControls];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CALayer *imageLayer = self.userPicImageView.layer;
    [imageLayer setCornerRadius:self.userPicImageView.frame.size.width / 2];
    [imageLayer setMasksToBounds:YES];
    
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

- (void)configureCurrentRecommendedValue
{
    NSInteger maxValue;
    if (debtMode) {
        maxValue = [[DataManager sharedInstance] valueForKey:DefaultRecommendedValueBorrow].intValue;
    }
    else {
        maxValue = [[DataManager sharedInstance] valueForKey:DefaultRecommendedValueLend].intValue;
    }
    
    NSInteger currentValue = [[DataManager sharedInstance] amountForType:debtMode ? BORROW_TYPE : LEND_TYPE];
    
    maxValue = MAX(0, maxValue - currentValue);
    
    [self.recommendedLabel setText:[NSString stringWithFormat:RecommendedFormat, debtMode ? BorrowType : LendType, [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol], (long)maxValue]];
}

- (void)setDebtMode:(BOOL)aDebtMode force:(BOOL)aForce
{
    if (aDebtMode != debtMode || aForce) {
        debtMode = aDebtMode;
        
        [self configureCurrentRecommendedValue];
        
//        [self.view setBackgroundColor:(debtMode ? BorrowColor : LendColor)];
        
        [self.borrowTypeLabel setText:(debtMode ? @"Borrow" : @"Lend")];
        self.borrowIcon.image = [UIImage imageNamed:(debtMode ? @"borrowIcon" : @"lendIcon")];
        
        if (self.debt) {
            NSString *labelName = debtMode ? @"Borrow details" : @"Lend details";
            [self setTitleName:labelName];
            
            [self.amountTextField setText:[NSString stringWithFormat:@"%.0lf", [self.debt.amount floatValue]]];
            
            [self.nameLabel setText:self.debt.user.name];
            
            if (self.debt.descriptionDebt) {
                [self.borrowTextView setText:self.debt.descriptionDebt];
            }
            
            if (self.debt.imageUrl) {
                UIImage *image = [DataManager imageForID:self.debt.imageUrl];
                
                if (image) {
                    [self.userPicImageView setImage:image];
                }
            }
        } else {
            NSString *labelName = debtMode ? @"Borrow" : @"Lend";
            [self setTitleName:labelName];
            [self.bottomAddDebtButton setTitle:labelName forState:UIControlStateNormal];
        }
        
        if (debtMode) {
            
        }
    }
}

- (void)setDebtMode:(BOOL)aDebtMode
{
    [self setDebtMode:aDebtMode force:NO];
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
    
    for (UIButton *button in self.addDebtButtons) {
        [button setEnabled:YES];
    }
    
    self.selectedContact = contact;
}

- (IBAction)addBorrowPressed:(id)sender
{
    if (self.nameLabel.text.length > 0 && self.selectedContact) {
        NSString *stringId = [NSString stringWithFormat:@"%@", self.selectedContact.recordID];
        
        if (self.selectedContact.thumbnail) {
            [DataManager saveImage:self.selectedContact.thumbnail withId:stringId];
        }
        
        User *user = [User fetchObjectWithParameters:@{@"idUser" : stringId}];
        
        if (!user) {
            user = [User object];
            user.idUser = stringId;
        }
        
        user.name = self.nameLabel.text;
        user.typeAccount = [NSNumber numberWithInteger:CONTACTS_TYPE];
        
        if (self.selectedContact.emails.count > 0) {
            user.email = [self.selectedContact.emails firstObject];
        }
        
        if (self.selectedContact.phones.count > 0) {
            user.phoneNumber = [self.selectedContact.phones firstObject];
        }
        
        if (self.selectedContact.thumbnail) {
            user.imageUrl = stringId;
        }
        
        Debt *debt = [Debt object];
        [user addDebtObject:debt];
        debt.user = user;
        
        debt.date = [NSDate date];
        
        if (![self.borrowTextView.text isEqualToString:DefaultDebtDetailsText]) {
            debt.descriptionDebt = self.borrowTextView.text;
        }
        
        debt.typeMoneyDebt = [self.currencyButton titleForState:UIControlStateNormal];
        debt.isClosed = @NO;
        debt.amount = [NSNumber numberWithFloat:[self.amountTextField.text floatValue]];
        
        if (self.selectedContact.thumbnail) {
            debt.imageUrl = stringId;
        }
        
        debt.typeDebt = [NSNumber numberWithInteger:debtMode ? BORROW_TYPE : LEND_TYPE];
        
        [[DataManager sharedInstance] save];
        
        [self backPressed:nil];
    }
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

- (IBAction)closeDebt:(id)sender
{
    self.alert = [[UIAlertView alloc] initWithTitle:nil
                                            message:@"Close record?"
                                           delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Confirm", nil];
    [self.alert show];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
            
        case MFMailComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMailPressed:(id)sender
{
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = nil;
    
    if (self.debt.user.email) {
        recipents = @[self.debt.user.email];
    }
    
    NSString *message = [self message];
    
    MFMailComposeViewController *messageController = [[MFMailComposeViewController alloc] init];
    messageController.mailComposeDelegate = self;
    [messageController setToRecipients:recipents];
    [messageController setMessageBody:message isHTML:NO];
    [messageController setSubject:[self subject]];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}


- (NSString *)message
{
    return [NSString stringWithFormat:(debtMode ? @"Hi\n\nI remember I owe you %@%@." : @"Hi\n\nRemember you still owe me %@%@?"), self.debt.amount, self.debt.typeMoneyDebt];
}

-(NSString *)subject
{
    return @"Dept";
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMessagePressed:(id)sender
{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = nil;
    
    if (self.debt.user.phoneNumber) {
        recipents = @[self.debt.user.phoneNumber];
    }
    
    NSString *message = [self message];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    [messageController setSubject:[self subject]];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)reminderPressed:(id)sender
{
    
}


#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView == self.alert) {
        self.alert = nil;
        if (self.debt) {
            self.debt.isClosed = @YES;
            
            [[DataManager sharedInstance] save];
            [self backPressed:nil];
        }
    }
}

#pragma mark keyboard manage selectors
- (void)keyboardDidShow:(NSNotification *)notification {
    
    
    if ([self.borrowTextView isFirstResponder]) {
        NSDictionary* info = [notification userInfo];
        
        NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
        keyBoardY = keyboardRect.origin.y;
        
        CGRect textFieldRect = self.borrowTextView.frame;
        
        float moveDiff = keyBoardY - (textFieldRect.origin.y + textFieldRect.size.height) - 20;
        if (moveDiff < 0) {
            
            currentViewYMargin = moveDiff;
            
            
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(self.view.frame.origin.x,
                                             self.view.frame.origin.y + moveDiff,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height - moveDiff);
            }];
        }
        else {
            currentViewYMargin = 0;
        }
    }

}

- (void)keyboardDidHide:(NSNotification *)notification {
    
    if (currentViewYMargin) {
        
        [UIView animateWithDuration:0.15 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x,
                                         self.view.frame.origin.y - currentViewYMargin,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height + currentViewYMargin);
        }];
        
        currentViewYMargin = 0;
    }
}

@end
