//
//  NGWAPIClient.m
//  ios-workshops
//
//  Created by Adrian Kashivskyy on 06.11.2015.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWAPIClient.h"
#import "NGWCategory.h"
#import "NGWVenue.h"

NSString * const NGWAPIClientErrorDomain = @"NGWAPIClientErrorDomain";

@interface NGWAPIClient ()

@property (strong, nonatomic, readonly) NSString *clientID;
@property (strong, nonatomic, readonly) NSString *clientSecret;
@property (strong, nonatomic, readonly) NSURLSession *session;

@end

#pragma mark -

@implementation NGWAPIClient

@synthesize session = _session;

#pragma mark Initialization

- (instancetype)initWithClientIdentifier:(NSString *)clientID clientSecret:(NSString *)clientSecret {
	if ((self = [super init])) {
		_clientID = clientID;
		_clientSecret = clientSecret;
	}
	return self;
}

#pragma mark Accessors

- (NSURL *)baseURL {
	return [NSURL URLWithString:@"https://api.foursquare.com/v2/"];
}

- (NSArray<NSURLQueryItem *> *)defaultQueryItems {
	return @[
		[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID],
		[NSURLQueryItem queryItemWithName:@"client_secret" value:self.clientSecret],
		[NSURLQueryItem queryItemWithName:@"v" value:@"20151111"],
		[NSURLQueryItem queryItemWithName:@"m" value:@"foursquare"]
	];
}

- (NSURLSession *)session {
	return _session ?: (_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]);
}

#pragma mark Support methods

- (NSURLRequest *)URLRequestWithMethod:(NSString *)method URLString:(NSString *)string queryItems:(NSArray<NSURLQueryItem *> *)items {
	NSURL *URL = [NSURL URLWithString:string relativeToURL:self.baseURL];
	NSURLComponents *components = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:YES];
	components.queryItems = [self.defaultQueryItems arrayByAddingObjectsFromArray:items];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:components.URL];
	request.HTTPMethod = method;
	return request;
}

- (NSURLSessionTask *)resumeDataTaskWithRequest:(NSURLRequest *)request completion:(void(^)(NSDictionary<NSString *, id> *json, NSError *error))completion {
	NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
		if (statusCode < 200 || statusCode > 299) {
			completion(nil, [NSError errorWithDomain:NGWAPIClientErrorDomain code:0 userInfo:@{
				NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Unacceptable status code: %lu", statusCode]
			}]);
		} else if (!error && data != nil) {
			NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			if (!error) {
				completion(json, nil);
			} else {
				completion(json, error);
			}
		} else {
			completion(nil, error);
		}
    }];
    [task resume];
    return task;
}

#pragma mark Venues search

- (void)getVenuesNearCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationAccuracy)radius query:(NSString *)query categories:(NSArray<NGWCategory *> *)categories completion:(void (^)(NSArray<NGWVenue *> *, NSError *))completion {
	NSURLRequest *request = [self URLRequestWithMethod:@"GET" URLString:@"venues/search" queryItems:@[
		[NSURLQueryItem queryItemWithName:@"intent" value:@"browse"],
		[NSURLQueryItem queryItemWithName:@"ll" value:[NSString stringWithFormat:@"%lf,%lf", coordinate.latitude, coordinate.longitude]],
		[NSURLQueryItem queryItemWithName:@"radius" value:@(radius).stringValue],
		[NSURLQueryItem queryItemWithName:@"query" value:(query ?: @"")],
		[NSURLQueryItem queryItemWithName:@"categoryId" value:(categories ? [^{
			NSMutableArray *categoryIDs = [NSMutableArray array];
			for (NGWCategory *category in categories) {
				[categoryIDs addObject:category.identifier];
			}
			return categoryIDs;
		}() componentsJoinedByString:@","] : @"")]
	]];
	[self resumeDataTaskWithRequest:request completion:^(NSDictionary<NSString *,id> *json, NSError *error) {
		if (!error) {
			NSArray<NGWVenue *> *venues = [NGWVenue venuesWithJSONArray:json[@"response"][@"venues"] error:&error];
			if (!error) {
				completion(venues, nil);
			} else {
				completion(nil, error);
			}
		} else {
			completion(nil, error);
		}
	}];
}

#pragma mark Categories

- (void)getCategoriesWithCompletion:(void (^)(NSArray<NGWCategory *> *, NSError *))completion {
	NSURLRequest *request = [self URLRequestWithMethod:@"GET" URLString:@"venues/categories" queryItems:@[]];
	[self resumeDataTaskWithRequest:request completion:^(NSDictionary<NSString *,id> *json, NSError *error) {
		if (!error) {
			NSArray<NGWCategory *> *venues = [NGWCategory categoriesWithJSONArray:json[@"response"][@"categories"] error:&error];
			if (!error) {
				completion(venues, nil);
			} else {
				completion(nil, error);
			}
		} else {
			completion(nil, error);
		}
	}];
}

#pragma mark Photo 

- (NSURLSessionTask *)photoForVenue:(NGWVenue *)venue completion:(void (^)(UIImage * photo, NSError *error))completion{
    NSURLRequest *request = [self URLRequestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"venues/%@/photos", venue.identifier]
                                            queryItems:@[[NSURLQueryItem queryItemWithName:@"VENUE_ID" value:venue.identifier],
                                                         [NSURLQueryItem queryItemWithName:@"limit" value:@(1).stringValue],
                                                         ]];

    return [self resumeDataTaskWithRequest:request completion:^(NSDictionary<NSString *,id> *json, NSError *error) {
        if (!error) {
            
            NSDictionary<NSString *,id> *photos = json[@"response"][@"photos"];
            if ([photos[@"count"] integerValue] == 1) {
                NSString *prefix = [photos[@"items"] firstObject][@"prefix"];
                NSString *suffix = [photos[@"items"] firstObject][@"suffix"];
                [self photoWithPrefix:prefix andSuffix:suffix completion:^(UIImage *photo, NSError *error) {
                    completion(photo, error);
                }];
            }
        } else {
            completion(nil, error);
        }
    }];
}

- (void)photoWithPrefix:(NSString * )prefix andSuffix:(NSString *)suffix completion:(void (^)(UIImage * photo, NSError *error))completion{
    NSParameterAssert(prefix);
    NSParameterAssert(suffix);
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@100x100%@",prefix,suffix]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error]];
    
    completion(image, error);
}

@end
