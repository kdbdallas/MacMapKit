//
//  MKMultiPoint.h
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKShape.h>
#import <HBIMapKit/HBIMKGeometry.h>
#import <HBIMapKit/HBIMKTypes.h>

@interface HBIMKMultiPoint : HBIMKShape {
    CLLocationCoordinate2D *coordinates;
    NSUInteger coordinateCount;
}

@property (nonatomic, readonly) CLLocationCoordinate2D *coordinates;
@property (nonatomic, readonly) NSUInteger coordinateCount;

- (void)getCoordinates:(CLLocationCoordinate2D *)coords range:(NSRange)range;

@end
