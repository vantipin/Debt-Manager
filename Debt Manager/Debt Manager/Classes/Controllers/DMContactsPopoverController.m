//
//  DMContactsPopoverController.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMContactsPopoverController.h"
#import "APAddressBook.h"
#import "DMContactCell.h"

#define ContactCellId @"ContactCellId"

@interface DMContactsPopoverController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation DMContactsPopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContacts];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.contacts count];
}

- (void)cofigureCell:(DMContactCell *)aCell atIndex:(NSInteger)anIndex
{
    if (anIndex < self.contacts.count) {
        APContact *contact = self.contacts[anIndex];
        
        UIImage *contactImage = contact.thumbnail ? contact.thumbnail : [UIImage imageNamed:@"userAccountPic.png"];
        
        [aCell.avatarImageView setImage:contactImage];
        
        NSString *firstName = contact.firstName && [contact.firstName class] != [NSNull class] ? contact.firstName : @"";
        NSString *lastName = contact.lastName && [contact.lastName class] != [NSNull class] ? contact.lastName : @"";
        
        [aCell.contactNameLabel setText:[NSString stringWithFormat:@"%@%@", (firstName.length ? [NSString stringWithFormat:@"%@ ", firstName] : @""), lastName]];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMContactCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ContactCellId forIndexPath:indexPath];
    
    [self cofigureCell:cell atIndex:indexPath.row];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.contacts.count) {
        if (self.contactDelegate && [self.contactDelegate respondsToSelector:@selector(contactSelected:)]) {
            [self.contactDelegate contactSelected:self.contacts[indexPath.row]];
        }
    }
    
    return NO;
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
        self.contacts = contacts ? contacts : @[];
        [self.collectionView reloadData];
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)donePressed:(id)sender {
    if (self.contactDelegate && [self.contactDelegate respondsToSelector:@selector(donePressedForContacts)]) {
        [self.contactDelegate donePressedForContacts];
    }
}
@end
