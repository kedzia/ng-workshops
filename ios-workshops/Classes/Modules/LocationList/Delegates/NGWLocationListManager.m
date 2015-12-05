//
//  NGWLocationListManager.m
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 09/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import "NGWLocationListManager.h"
#import "NGWCollectionViewCell.h"
#import "NGWVenue.h"

@interface NGWLocationListManager ()
@property (strong, nonatomic, nullable) NSArray<NGWVenue *> *locations;
@property (weak, nonatomic, nullable) UICollectionView *collectionView;
@end

@implementation NGWLocationListManager

#pragma mark - public

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        _locations = @[];
        [_collectionView registerClass:[NGWCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
        _sessionTaskDictionary = @{}.mutableCopy;
    }
    return self;
}

- (void)updateCollectionWithItems:(NSArray<NGWVenue *> *)locations {
    @synchronized(self) {
        self.locations = locations;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    @synchronized(self) {
        return [self.locations count];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NGWCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"identifier"
                                                                           forIndexPath:indexPath];
    cell.textLabel.text = [self.locations objectAtIndex:indexPath.row].name;
    [self loadPhotoForCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)loadPhotoForCell:(NGWCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSAssert(self.apiClient, @"Api client is nil");
     __block NSURLSessionTask *task = [self.apiClient photoForVenue:[self.locations objectAtIndex:indexPath.row]
                              completion:^(UIImage * _Nullable photo, NSError * _Nullable error) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      if ([cell.currentTask isEqual:task]) {
                                          cell.backgroundView = [[UIImageView alloc] initWithImage:photo];
                                      }
                                  });
                              }];
    cell.currentTask = task;
}
@end
