//
//  NGWMapAnnotationSpec.m
//  ios-workshops
//
//  Created by Patryk Kaczmarek on 12/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <Specta/Specta.h>

#import "NGWMapAnnotation.h"

SpecBegin(NGWMapAnnotation)

describe(@"NGWMapAnnotation", ^{

    __block NGWMapAnnotation *sut = nil;
    
    beforeEach(^{
        sut = [[NGWMapAnnotation alloc] init];
    });
    
    afterEach(^{
        sut = nil;
    });
    
    context(@"when newly initialized", ^{
        
        pending(@"should not be nil", ^{
            
        });

        it(@"should have default set coordinates", ^{
            expect(sut.coordinate).to.equal(CLLocationCoordinate2DMake(0, 0));
        });
        
        it(@"address should be nil", ^{
            expect(sut.address).beNil();
        });
    });
    
    context(@"when setting coordinate", ^{
        
        beforeEach(^{
            [sut setCoordinate:CLLocationCoordinate2DMake(10.9893903, -88.380983)];
        });
        
        pending(@"coordinates should be properly set", ^{
            
        });
    });
    
    context(@"when setting address", ^{
        
        beforeEach(^{
            sut.address = @"fixture.address";
        });
        
        pending(@"address should be properly set", ^{
            
        });
    });
});

SpecEnd
