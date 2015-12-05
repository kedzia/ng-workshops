//
//  NGWCategoriesDataProvider.h
//  ios-workshops
//
//  Created by Adam Kędzia on 05.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGWCategory.h"
#import "NGWAPIClient.h"

@protocol NGWCategoriesDataProviderProtovol <NSObject>

- (void)provideCategories:(void(^)(NSArray <NGWCategory *> *categories, NSError *error))completion;
- (NSArray <NGWCategory *> *)selectedCategories;
- (void)setSelectedCategory:(NGWCategory *)selectedCategory;

@end

@interface NGWCategoriesDataProvider : NSObject <NGWCategoriesDataProviderProtovol>

- (instancetype)initWithApiClient:(NGWAPIClient *)apiClient;
- (NSArray <NGWCategory *> *)selectedCategories;
- (void)setSelectedCategory:(NGWCategory *)selectedCategory;

@end
