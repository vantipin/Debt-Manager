//
//  DMContactCell.m
//  Debt Manager
//
//  Created by Pavel Stoma on 3/28/15.
//  Copyright (c) 2015 DM. All rights reserved.
//

#import "DMContactCell.h"

@implementation DMContactCell

-(void)awakeFromNib
{
    CALayer *imageLayer = self.avatarImageView.layer;
    [imageLayer setCornerRadius:self.avatarImageView.frame.size.width / 2];
    [imageLayer setMasksToBounds:YES];
}

@end
