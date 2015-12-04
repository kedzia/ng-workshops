//
//  NGWLocationViewController.h
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 04/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGWVenue.h"

@interface NGWLocationsListViewController : UIViewController
@property (strong, nonatomic) NSArray <NGWVenue *> *venueArray;
@end
