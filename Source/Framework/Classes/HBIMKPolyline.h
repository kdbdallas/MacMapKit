//
//  MKPolyline.h
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKMultiPoint.h>
#import <HBIMapKit/HBIMKOverlay.h>

@interface HBIMKPolyline : HBIMKMultiPoint <HBIMKOverlay>

+ (HBIMKPolyline *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end

