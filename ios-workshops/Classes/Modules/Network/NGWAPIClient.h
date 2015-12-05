//
//  NGWAPIClient.h
//  ios-workshops
//
//  Created by Adrian Kashivskyy on 06.11.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NGWCategory;
@class NGWVenue;

extern  NSString * _Nonnull const NGWAPIClientErrorDomain;

@interface NGWAPIClient : NSObject

NS_ASSUME_NONNULL_BEGIN

/// Creates a session instance with the given configuration.
///
/// @param clientID The Foursquare client ID of the app.
/// @param clientSecret The Foursquare client secret of the app.
///
/// @returns A new instance of the receiver.
- (instancetype)initWithClientIdentifier:(NSString *)clientID clientSecret:(NSString *)clientSecret;

/// Gets the categories.
///
/// @param completion The completion block.
- (void)getCategoriesWithCompletion:(void (^)(NSArray<NGWCategory *> * _Nullable categories, NSError * _Nullable error))completion;

/// Creates a task for getting venues.
///
/// @param coordinate The coordinate to search near.
/// @param radius The accuracy of the search.
/// @param completion The completion block.
- (void)getVenuesNearCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationAccuracy)radius query:(nullable NSString *)query categories:(nullable NSArray<NGWCategory *> *)categories completion:(void (^)(NSArray<NGWVenue *> * _Nullable venues, NSError * _Nullable error))completion;

- (NSURLSessionTask *)photoForVenue:(NGWVenue *)venue completion:(void (^)(UIImage * _Nullable photo, NSError * _Nullable error))completion;

NS_ASSUME_NONNULL_END

@end

#pragma mark -

@interface NGWAPIClient (Unavailable)

- (nullable instancetype)init NS_UNAVAILABLE;

@end
