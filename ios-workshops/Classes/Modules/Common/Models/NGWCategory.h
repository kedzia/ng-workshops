//
//  NGWCategory.h
//  ios-workshops
//
//  Created by Adrian Kashivskyy on 12.11.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGWCategory : NSObject

NS_ASSUME_NONNULL_BEGIN

/// Initializes a category.
///
/// @param dictionary The JSON dictionary representation of a category.
/// @param error An error which might have occured during deserialization.
///
/// @returns An instance of category model or `nil` if an error occured.
- (nullable instancetype)initWithJSONDictionary:(NSDictionary<NSString *, id> *)dictionary error:(NSError * _Nullable * _Nullable)error;

/// Creates an array of deserialized categories from an array of JSON objects.
///
/// @param array The JSON array containing JSON dictionaries received from the API.
/// @param error An error which might have occured during deserialization.
///
/// @returns An array of categories or `nil` if an error occured.
+ (nullable NSArray<NGWCategory *> *)categoriesWithJSONArray:(NSArray<NSDictionary<NSString *, id> *> *)array error:(NSError **)error;

/// The unique identifier of the category.
@property (strong, nonatomic, readonly) NSString *identifier;

/// The name of the category.
@property (strong, nonatomic, readonly) NSString *name;

/// The array of sub-categories.
@property (strong, nonatomic, readonly) NSArray<NGWCategory *> *childCategories;

/// Url to icon image
@property (strong, nonatomic, readonly) NSURL *iconURL;

NS_ASSUME_NONNULL_END

@end
