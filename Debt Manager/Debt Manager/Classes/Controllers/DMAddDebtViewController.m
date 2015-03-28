//
//  DMAddDebtViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMAddDebtViewController.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "DataManager.h"

#define DefaultRecommendedValue @"DefaultRecommendedValue"

#define BorrowColor [UIColor colorWithRed:240. / 255. green:1. blue:240. / 255. alpha:1.]
#define LendColor [UIColor colorWithRed:1. green:240. / 255. blue:240. / 255. alpha:1.]

#define BorrowType @"borrow"
#define LendType @"lend"
#define RecommendedFormat @"Your recommended amount to %@ %@%li\nYou can configure limits via Settings"

@interface DMAddDebtViewController ()

@end

@implementation DMAddDebtViewController
@synthesize debtMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContacts];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.showContactsOnViewWillAppear) {
        self.showContactsOnViewWillAppear = NO;
        [];
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

- (void)loadContacts
{
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    addressBook.sortDescriptors = @[
                                    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                    ];
    
    addressBook.fieldsMask = APContactFieldFirstName | APContactFieldLastName | APContactFieldPhones | APContactFieldEmails | APContactFieldThumbnail | APContactFieldRecordID;
    
    [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
        for (APContact *contact in contacts) {
//            NSLog(@"%@ %@.\n%@\n%@", contact.firstName, contact.lastName, contact.phones, contact.emails);
//            
            if (contact.thumbnail) {
//                UIImage *image = contact.thumbnail;
//                NSString *contactId = [NSString stringWithFormat:@"%@", contact.recordID];
//                
//                [[DataManager sharedInstance] saveImage:image withId:contactId];
//                
//                UIImage *cImage = [[DataManager sharedInstance] imageForID:contactId];
//                NSLog(@"test");
            }
        }
    }];

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
    
}

- (IBAction)addBorrowPressed:(id)sender
{
    
}

- (IBAction)debtTypePressed:(id)sender
{
    self.debtMode = !debtMode;
}

@end
