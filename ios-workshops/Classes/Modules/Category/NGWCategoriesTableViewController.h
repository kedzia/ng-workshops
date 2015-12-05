//
//  NGWCategoriesTableViewController.h
//  ios-workshops
//
//  Created by Adam Kędzia on 05.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGWCategoriesDataProvider.h"

@interface NGWCategoriesTableViewController : UITableViewController

- (instancetype)initWithCategriesProvider:(id<NGWCategoriesDataProviderProtovol>)categoriesProvider;
@end
