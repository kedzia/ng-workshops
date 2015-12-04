//
//  NGWLocationRetriever.h
//  ios-workshops
//
//  Created by Patryk Kaczmarek on 12/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGWLocationRetriever : NSObject

/**
 *  Underneath location manager used for retrieving user location.
 */
@property (strong, nonatomic, nonnull) CLLocationManager *locationManager;

/**
 *  Obtains user's device location. Requests for permission if needed.
 *  If status is equal to kCLAuthorizationStatusDenied them immediately invokes completion block with error (code -666).
 */
- (void)obtainUserLocationWithCompletion:(void (^_Nullable)(CLLocation * _Nullable, NSError * _Nullable))completion;

@end
