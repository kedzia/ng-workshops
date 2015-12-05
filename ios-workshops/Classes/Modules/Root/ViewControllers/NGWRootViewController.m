//
//  NGWRootViewController.m
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 03/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWRootViewController.h"

#import "NGWMapViewController.h"
#import "NGWLocationsListViewController.h"
#import "NGWAPIClient.h"
#import "NGWLocationRetriever.h"

@import PureLayout;

@interface NGWRootViewController() <NGWMapViewControllerDelegate, UITextFieldDelegate>
@property (assign, nonatomic) BOOL didSetConstraints;
@property (strong, nonatomic, nonnull) NGWMapViewController *mapVc;
@property (strong, nonatomic, nonnull) NGWLocationsListViewController *locationsListVc;
@property (strong, nonatomic, nonnull) NGWAPIClient *apiClient;
@property (strong, nonatomic, nonnull) NGWLocationRetriever *locationRetriever;
@property (strong, nonatomic, nonnull) UITextField *searchTextFiled;

@end

@implementation NGWRootViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationRetriever = [NGWLocationRetriever new];
        _apiClient = [[NGWAPIClient alloc] initWithClientIdentifier:@"OJS3S0YKZRAD3KWCZ4XFU5NHNZOBDR2SGFPGV50MMERJKSED"
                                                       clientSecret:@"ZWO5GWQ55ZF1CQ1ZMPPQSQISOENCPTUBMNSZDAUXAT0NBVQE"];
    }
    return self;
}

- (void)loadView {
    self.view = [UIView new];
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mapVc = [NGWMapViewController new];
    _mapVc.delegate = self;
    _locationsListVc = [NGWLocationsListViewController new];
    
    [self addChildViewController:self.mapVc];
    [self.view addSubview:self.mapVc.view];
    [self.mapVc didMoveToParentViewController:self];
    
    [self addChildViewController:self.locationsListVc];
    [self.view addSubview:self.locationsListVc.view];
    [self.locationsListVc didMoveToParentViewController:self];
    self.locationsListVc.locationListManager.apiClient = self.apiClient;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter-icon"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Locate me!", nil) style:UIBarButtonItemStylePlain target:self action:@selector(locateMeBarButtonDidTap:)];
    self.searchTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 21.0)];
    self.searchTextFiled.backgroundColor = [UIColor colorWithWhite:0.9
                                                             alpha:1.0];
    self.navigationItem.titleView = self.searchTextFiled;
    self.searchTextFiled.returnKeyType = UIReturnKeyDone;
    self.searchTextFiled.delegate = self;

}

#pragma mark - Layout

- (void)updateViewConstraints {
    
    if (!self.didSetConstraints) {
        [self.mapVc.view autoPinToTopLayoutGuideOfViewController:self withInset:0];
        [self.mapVc.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.mapVc.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.mapVc.view autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view withMultiplier:0.33];
        
        [self.locationsListVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mapVc.view];
        [self.locationsListVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        self.didSetConstraints = YES;
    }

    [super updateViewConstraints];
}

#pragma mark - Handling location update

- (void)updateListForLocation:(nonnull CLLocation *)location {
    [self updateListForLocation:location andQuery:@""];
}

- (void)updateListForLocation:(nonnull CLLocation *)location andQuery:(NSString *)query {
    __weak typeof(self) weakSelf = self;
    [self.apiClient getVenuesNearCoordinate:location.coordinate radius:kCLLocationAccuracyKilometer query:query categories:nil completion:^(NSArray<NGWVenue *> * _Nullable venues, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
            NSArray *newVenues = venues ? : @[];
            [strongSelf.locationsListVc.locationListManager updateCollectionWithItems:newVenues];
    }];
}

- (void)locateMeBarButtonDidTap:(UIBarButtonItem *)button {
    [self.locationRetriever obtainUserLocationWithCompletion:^(CLLocation * _Nullable location, NSError * _Nullable error) {
        NSLog(@"%.4f, %.4f", location.coordinate.latitude, location.coordinate.latitude);
    }];
}

#pragma mark - NGWMapViewControllerDelegate

- (void)mapViewController:(NGWMapViewController *)controller didChangeToLocation:(nonnull CLLocation *)location {
    [self updateListForLocation:location];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    __weak typeof(self) weakSelf = self;
    [self.locationRetriever obtainUserLocationWithCompletion:^(CLLocation * _Nullable location, NSError * _Nullable error) {
        typeof(self) strongSelf = weakSelf;
        
        if (error) {
            switch (error.code) {
                case -666:
                    [strongSelf presentLocationServiceAlert];
                    break;
                default:
                    break;
            }
            return ;
        }
        [strongSelf updateListForLocation:location andQuery:textField.text];
    }];
    [textField resignFirstResponder];
    return YES;
}

- (void)presentLocationServiceAlert {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Turn on location services", nil)
                                                                       message:NSLocalizedString(@"To enable search please, turn on location services in Privacy Setings", nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}

@end
