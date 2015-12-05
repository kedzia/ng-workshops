//
//  NGWLocationListManager.h
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 09/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

@import UIKit;
#import "NGWAPIClient.h"
@class NGWVenue;

@interface NGWLocationListManager : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NGWAPIClient *apiClient;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

/// Updates venue objects and reloads collection view
///
/// @param locations Array of NGWVenue objects that should be displayed
///
- (void)updateCollectionWithItems:(NSArray <NGWVenue *> *)locations;
@end
