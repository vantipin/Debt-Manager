//
//  DebtCell.m
//  Debt Manager
//
//  Created by Vlad Antipin on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DebtCell.h"
#import "DataManager.h"

@interface DebtCell()

@property (nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) IBOutlet UIImageView *debtTypeImage;
@property (nonatomic) IBOutlet UILabel *debtTypeLabel;
@property (nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic) IBOutlet UILabel *debtDateLabel;
@property (nonatomic) IBOutlet UILabel *debtAmountLabel;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation DebtCell

- (void)awakeFromNib {
    // Initialization code
    
    CALayer *imageLayer = self.image.layer;
    [imageLayer setCornerRadius:self.image.frame.size.width / 2];
    [imageLayer setMasksToBounds:YES];
}

- (void)setDebt:(Debt *)debt
{
    
    if (debt) {
        _debt = debt;
        if (debt.user) {
            self.userNameLabel.text = debt.user.name;
        }
        else {
            self.userNameLabel.text = @"";
        }
        
        self.activity.hidden = YES;
        
        self.debtDateLabel.text = [DataManager standartDateFormat:debt.date.timeIntervalSince1970];
        self.debtAmountLabel.text = [NSString stringWithFormat:@"%@ %@",debt.typeMoneyDebt, debt.amount];
        
        self.debtTypeImage.image = [[DataManager sharedInstance] imageForType:debt.typeDebt.intValue];
        self.debtTypeLabel.text = [[DataManager sharedInstance] textForType:debt.typeDebt.intValue];
        
        [self setUserImageWithURL:debt.user.imageUrl];
        
    }
}

- (void)setUserImageWithURL:(NSString *)url
{
    if (url) {
        self.image.image = nil;
        self.activity.hidden = NO;
        [self.activity startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [DataManager imageForID:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.activity.hidden = YES;
                [self.activity stopAnimating];
                if (image) {
                    self.image.image = image;
                }
                else {
                    self.image.image = [UIImage imageNamed:@"userAccountPic.png"];
                }
            });
        });
    }
    else {
        self.image.image = [UIImage imageNamed:@"userAccountPic.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
