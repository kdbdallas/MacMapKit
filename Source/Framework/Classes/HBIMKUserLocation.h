//
//  MKUserLocation.h
//  MapKit
//
//  Created by Rick Fillion on 7/11/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKAnnotation.h>

@class CLLocation;

@interface HBIMKUserLocation : NSObject <HBIMKAnnotation> {
    BOOL updating;
    NSString *title;
    NSString *subtitle;
}

// Returns YES if the user's location is being updated.
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

// Returns nil if the owning MKMapView's showsUserLocation is NO or the user's location has yet to be determined.
@property (weak, readonly, nonatomic) CLLocation *location;

// The title to be displayed for the user location annotation.
@property (strong, nonatomic) NSString *title;

// The subtitle to be displayed for the user location annotation.
@property (strong, nonatomic) NSString *subtitle;

- (void)_setLocation:(CLLocation *)aLocation;
- (void)_setUpdating:(BOOL)value;

@end
