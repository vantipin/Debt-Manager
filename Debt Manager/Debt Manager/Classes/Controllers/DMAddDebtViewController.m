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

@interface DMAddDebtViewController ()

@end

@implementation DMAddDebtViewController
@synthesize debtMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContacts];
    // Do any additional setup after loading the view.
}

- (void)setDebtMode:(BOOL)aDebtMode
{
    if (aDebtMode != debtMode) {
        debtMode = aDebtMode;
        
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
            NSLog(@"%@ %@.\n%@\n%@", contact.firstName, contact.lastName, contact.phones, contact.emails);
            
//            if (contact.thumbnail) {
//                UIImage *image = contact.thumbnail;
//                NSString *contactId = [NSString stringWithFormat:@"%@", contact.recordID];
//                
//                [[DataManager sharedInstance] saveImage:image withId:contactId];
//                
//                UIImage *cImage = [[DataManager sharedInstance] imageForID:contactId];
//                NSLog(@"test");
//            }
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

@end
