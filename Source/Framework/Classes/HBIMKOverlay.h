/*
 *  MKOverlay.h
 *  MapKit
 *
 *  Created by Rick Fillion on 7/12/10.
 *  Copyright 2010 Centrix.ca. All rights reserved.
 *
 */

#import <HBIMapKit/HBIMKAnnotation.h>
#import <HBIMapKit/HBIMKTypes.h>
#import <HBIMapKit/HBIMKGeometry.h>


@protocol HBIMKOverlay <HBIMKAnnotation>

@required

// From HBIMKAnnotation, for areas this should return the centroid of the area.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
