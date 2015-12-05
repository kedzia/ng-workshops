//
//  NGWCategory.m
//  ios-workshops
//
//  Created by Adrian Kashivskyy on 12.11.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWCategory.h"

@interface NGWCategory ()
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<NGWCategory *> *childCategories;
@property (strong, nonatomic) NSURL *iconURL;
@end

@implementation NGWCategory

#pragma mark Initialization

- (instancetype)initWithJSONDictionary:(NSDictionary<NSString *, id> *)json error:(NSError * __autoreleasing *)error {
	if ((self = [super init])) {
        self.name = json[@"name"];
        self.identifier = json[@"id"];
        NSMutableArray *result = @[].mutableCopy;
        for (NSDictionary<NSString *, id> *data in json[@"categories"]) {
            NGWCategory *category = [[NGWCategory alloc] initWithJSONDictionary:data error:error];
            if (category) {
                [result addObject:category];
            }
        }
        self.childCategories = [NSArray arrayWithArray:result];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_44%@", json[@"icon"][@"prefix"], json[@"icon"][@"suffix"]];
        self.iconURL = [NSURL URLWithString:urlString];
	}
	return self;
}


+ (NSArray<NGWCategory *> *)categoriesWithJSONArray:(NSArray<NSDictionary<NSString *, id> *> *)array error:(NSError * __autoreleasing *)error {
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (NSDictionary<NSString *, id> *dictionary in array) {
		NGWCategory *category = [[NGWCategory alloc] initWithJSONDictionary:dictionary error:error];
		if (*error != nil) {
			return nil;
		} else {
			[mutableArray addObject:category];
		}
	}
	return [NSArray arrayWithArray:mutableArray];
}

@end
