//
//  MKCircle.h
//  MapKit
//
//  Created by Rick Fillion on 7/12/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import <HBIMapKit/HBIMKShape.h>
#import <HBIMapKit/HBIMKOverlay.h>
#import <HBIMapKit/HBIMKGeometry.h>

@interface HBIMKCircle : HBIMKShape <HBIMKOverlay> {
    @package
    CLLocationCoordinate2D coordinate;
    CLLocationDistance radius;
}

+ (HBIMKCircle *)circleWithCenterCoordinate:(CLLocationCoordinate2D)coord radius:(CLLocationDistance)radius;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDistance radius;
@property (nonatomic, readonly) HBIMKCoordinateRegion region;

@end
