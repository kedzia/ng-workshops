//
//  NGWLocationViewController.m
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 04/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWLocationsListViewController.h"


@import PureLayout;

@interface NGWLocationsListViewController ()
@property (assign, nonatomic) BOOL didSetConstraints;

@property (strong, nonatomic) UICollectionView *locationsListCollectionView;
@end

@implementation NGWLocationsListViewController

#pragma mark - Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)loadView {
    self.view = [UIView new];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize =CGSizeMake(100., 100.);
    self.locationsListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    self.locationsListCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.locationsListCollectionView];
}

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.locationListManager = [[NGWLocationListManager alloc] initWithCollectionView:self.locationsListCollectionView];
    self.locationsListCollectionView.delegate = self.locationListManager;
    self.locationsListCollectionView.dataSource = self.locationListManager;
    self.locationsListCollectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Layout

- (void)updateViewConstraints {
    
    if (!self.didSetConstraints) {
        [self.locationsListCollectionView autoPinEdgesToSuperviewEdges];
        
    }
    
    [super updateViewConstraints];
}
@end
