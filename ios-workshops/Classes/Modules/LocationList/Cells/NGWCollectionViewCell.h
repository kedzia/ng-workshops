//
//  NGWCollectionViewCell.h
//  ios-workshops
//
//  Created by Adam Kędzia on 04.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGWCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) NSURLSessionTask *currentTask;
@end
