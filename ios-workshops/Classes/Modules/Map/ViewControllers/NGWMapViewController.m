//
//  NGWMapViewController.m
//  ios-workshops
//
//  Created by Kamil Tomaszewski on 04/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <PureLayout/PureLayout.h>

#import "NGWMapViewController.h"
#import "NGWMapAnnotation.h"
#import "NGWLocationFormatter.h"
#import "NGWGeocoder.h"

static NSString *NGWAnnotationReuseIdentifier = @"NGWAnnotationReuseIdentifier";

@interface NGWMapViewController () <MKMapViewDelegate>

@property (assign, nonatomic) BOOL didSetConstraints;
@property (strong, nonatomic, nonnull) MKMapView *mapView;
@property (strong, nonatomic, nonnull) NGWMapAnnotation *annotation;

@end

@implementation NGWMapViewController

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [UIView new];
    
    self.mapView = [MKMapView newAutoLayoutView];
    
    [self.view addSubview:self.mapView];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self setupGestures];
}
#pragma mark - Layout

- (void)updateViewConstraints {
    
    if (!self.didSetConstraints) {
        [self.mapView autoPinEdgesToSuperviewEdges];
        
        self.didSetConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (void)dealloc {
    self.mapView.delegate = nil;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:NGWAnnotationReuseIdentifier];
    
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NGWAnnotationReuseIdentifier];
        pin.animatesDrop = YES;
        pin.draggable = YES;
        pin.canShowCallout = YES;
    } else {
        pin.annotation = annotation;
    }
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
        
        CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
        [annotationView.annotation setCoordinate:coordinate];
        [self updateLocationBasedOnCoordinate:coordinate];
    }
}

#pragma mark - UIGestureRecognizers

- (void)didDropPin:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self.mapView removeAnnotation:self.annotation];
    [self.annotation setCoordinate:[self cooridnateFromRecognizerLocation:recognizer]];
    [self.mapView addAnnotation:self.annotation];
    
    [self updateLocationBasedOnCoordinate:self.annotation.coordinate];
}

#pragma mark - Public

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated {
    [self.mapView setCenterCoordinate:coordinate animated:animated];
}

#pragma mark - Private

- (void)setupGestures {
    
    UILongPressGestureRecognizer *dropPinGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didDropPin:)];
    dropPinGestureRecognizer.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:dropPinGestureRecognizer];
}

- (CLLocationCoordinate2D)cooridnateFromRecognizerLocation:(UIGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    return [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
}

- (void)updateLocationBasedOnCoordinate:(CLLocationCoordinate2D)coordinate {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    self.annotation.address = nil;
    
    if ([self.delegate respondsToSelector:@selector(mapViewController:didChangeToLocation:)]) {
        [self.delegate mapViewController:self didChangeToLocation:location];
    }
    
    __weak typeof(self) weakifiedSelf = self;
    
    NGWGeocoder *geocoder = [[NGWGeocoder alloc] init];
    [geocoder reverseGeocode:coordinate withCompletion:^(CLPlacemark * _Nullable placemark, NSError * _Nullable error) {
        
        if (!error) {
            weakifiedSelf.annotation.address = [NGWLocationFormatter formattedLocationStringForPlacemark:placemark];
        }
        
        [weakifiedSelf.mapView selectAnnotation:weakifiedSelf.annotation animated:YES];
    }];
}

#pragma mark - Accessors

- (NGWMapAnnotation *)annotation {
    if (!_annotation) {
        _annotation = [[NGWMapAnnotation alloc] init];
    }
    return _annotation;
}

@end
