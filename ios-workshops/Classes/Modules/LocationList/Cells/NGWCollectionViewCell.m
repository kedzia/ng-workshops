//
//  NGWCollectionViewCell.m
//  ios-workshops
//
//  Created by Adam Kędzia on 04.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWCollectionViewCell.h"

@import PureLayout;
@implementation NGWCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor colorWithWhite:0. alpha:.5];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 2;
        [self.contentView addSubview:_textLabel];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.currentTask = nil;
    self.backgroundView = nil;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.textLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];

}
@end
