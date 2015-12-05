//
//  NGWCategoriesDataProvider.m
//  ios-workshops
//
//  Created by Adam Kędzia on 05.12.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWCategoriesDataProvider.h"

@interface NGWCategoriesDataProvider ()
@property (weak, nonatomic) NGWAPIClient *apiClient;
@property (strong, nonatomic) NGWCategory * selectedCategory;
@end
@implementation NGWCategoriesDataProvider

- (instancetype)initWithApiClient:(NGWAPIClient *)apiClient{
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (void)provideCategories:(void(^)(NSArray <NGWCategory *> *categories, NSError *error))completion {
    [self.apiClient getCategoriesWithCompletion:^(NSArray<NGWCategory *> * _Nullable categories, NSError * _Nullable error) {
        completion(categories, error);
    }];
}


- (NSArray <NGWCategory *> *)selectedCategories {
    return self.selectedCategory ? @[self.selectedCategory] : @[];
}


@end
