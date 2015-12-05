//
//  NGWVenue.m
//  ios-workshops
//
//  Created by Adrian Kashivskyy on 06.11.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWVenue.h"
@import Contacts;

@implementation NGWVenue

#pragma mark Initialization

- (instancetype)initWithJSONDictionary:(NSDictionary<NSString *, id> *)json error:(NSError * __autoreleasing *)error {
	if ((self = [super init])) {
		_identifier = json[@"id"];
		_name = json[@"name"];
		_distance = ((NSNumber *)(json[@"location"][@"distance"])).doubleValue;
		_mapItem = ^{
			MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:(CLLocationCoordinate2D){
				.latitude = ((NSNumber *)(json[@"location"][@"lat"])).doubleValue,
				.longitude = ((NSNumber *)(json[@"location"][@"lng"])).doubleValue
			} addressDictionary:@{
                
				CNPostalAddressStreetKey: json[@"location"][@"address"] ?: @"",
				CNPostalAddressPostalCodeKey: json[@"location"][@"postalCode"] ?: @"",
				CNPostalAddressISOCountryCodeKey: json[@"location"][@"cc"] ?: @"",
				CNPostalAddressCityKey: json[@"location"][@"city"] ?: @"",
				CNPostalAddressStateKey: json[@"location"][@"state"] ?: @""
			}];
			MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
			item.name = json[@"name"];
			item.phoneNumber = json[@"contact"][@"phone"];
			item.url = [NSURL URLWithString:json[@"url"]];
			return item;
		}();
	}
	return self;
}

+ (NSArray<NGWVenue *> *)venuesWithJSONArray:(NSArray<NSDictionary<NSString *, id> *> *)array error:(NSError * __autoreleasing *)error {
	NSMutableArray *mutableArray = [NSMutableArray array];
	for (NSDictionary<NSString *, id> *dictionary in array) {
		NGWVenue *venue = [[NGWVenue alloc] initWithJSONDictionary:dictionary error:error];
		if (*error != nil) {
			return nil;
		} else {
			[mutableArray addObject:venue];
		}
	}
	return [NSArray arrayWithArray:mutableArray];
}
@end
