//
//  ViewController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMMainViewController.h"
#import "APAddressBook.h"
#import "APContact.h"

@interface DMMainViewController ()

@end

@implementation DMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    addressBook.sortDescriptors = @[
                                    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                    ];
    
    addressBook.fieldsMask = APContactFieldFirstName | APContactFieldLastName | APContactFieldPhones | APContactFieldEmails | APContactFieldThumbnail;
    
    [addressBook loadContacts:^(NSArray *contacts, NSError *error) {
        for (APContact *contact in contacts) {
            NSLog(@"%@ %@.\n%@\n%@", contact.firstName, contact.lastName, contact.phones, contact.emails);
        }
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
