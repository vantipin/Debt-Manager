//
//  DMContactsPopoverController.h
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMViewController.h"
#import "APContact.h"

@protocol DMContactsDelegate <NSObject>

- (void)donePressedForContacts;
- (void)contactSelected:(APContact *)contact;

@end

@interface DMContactsPopoverController : DMViewController

@property (nonatomic, strong) NSArray *contacts;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id<DMContactsDelegate> contactDelegate;

- (IBAction)donePressed:(id)sender;


@end
