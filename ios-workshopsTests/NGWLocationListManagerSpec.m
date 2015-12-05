//
//  NGWLocationListManagerSpec.m
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 12/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "NGWLocationListManager.h"
#import "NGWVenue.h"
#import "NGWCollectionViewCell.h"

SpecBegin(NGWLocationListManager)

     /**  SPEC HELPERS BEGIN **/

    NSArray<NGWVenue *> * (^setupVenueArray)(NSUInteger) = ^NSArray <NGWVenue *> *(NSUInteger numberOfItems) {
        NSMutableArray <NGWVenue *>*venueArray = [NSMutableArray array];
        for(NSUInteger i = 0; i < numberOfItems; i++) {
            NGWVenue *mockVenue = [OCMockObject mockForClass:[NGWVenue class]];
            OCMStub([mockVenue name]).andReturn(@"mockName");
            [venueArray addObject:mockVenue];
            
        }
        return venueArray.copy;
    };

    /**  SPEC HELPERS END **/


    /** ACTUAL SPEC BELOW **/

    __block NGWLocationListManager *sut;
    __block UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];


    beforeEach(^{
        sut = [[NGWLocationListManager alloc] initWithCollectionView:cv];
    });

    afterEach(^{
        sut = nil;
    });

    context(@"When updating", ^{
        describe(@"with 3 items", ^{
            beforeEach(^{
                [sut updateCollectionWithItems:setupVenueArray(3)];
            });
            
            it(@"should return 3 items", ^{
                NSUInteger itemsCount = [sut collectionView:cv numberOfItemsInSection:0];
                expect(itemsCount).to.equal(3);
            });
        });
        
        describe(@"with 1 item or more", ^{
            beforeEach(^{
                [sut updateCollectionWithItems:setupVenueArray(1)];
            });
            
            it(@"should return a valid cell", ^{
                __kindof UICollectionViewCell *cell = [sut collectionView:cv cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                expect(cell).toNot.beNil();
            });
        });
        
    });
SpecEnd
