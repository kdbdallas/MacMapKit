//
//  MKPolygon.h
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKMultiPoint.h>
#import <HBIMapKit/HBIMKOverlay.h>

@interface HBIMKPolygon : HBIMKMultiPoint <HBIMKOverlay> {
    NSArray *interiorPolygons;
}

@property (readonly) NSArray *interiorPolygons;

+ (HBIMKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
+ (HBIMKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;


@end

