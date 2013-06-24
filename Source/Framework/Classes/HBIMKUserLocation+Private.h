//
//  MKUserLocation+Private.h
//  MapKit
//
//  Created by Rick Fillion on 7/11/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKUserLocation.h>

@class CLLocation;

@interface HBIMKUserLocation (Private)

- (void)_setLocation:(CLLocation *)aLocation;
- (void)_setUpdating:(BOOL)value;

@end
