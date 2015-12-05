//
//  NGWCategoryTableViewCell.m
//  ios-workshops
//
//  Created by Adam Kędzia on 05.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWCategoryTableViewCell.h"
@import PureLayout;

@implementation NGWCategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.name = [UILabel new];
        [self.contentView addSubview:self.name];
        self.categoryImageView = [UIImageView new];
        [self.contentView addSubview:self.categoryImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.categoryImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5., 5., 5., 5.) excludingEdge:ALEdgeRight];
    [self.categoryImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.categoryImageView];
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.categoryImageView withOffset:5.];
    [self.name autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
