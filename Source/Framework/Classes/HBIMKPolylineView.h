//
//  MKPolylineView.h
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKPolyline.h>
#import <HBIMapKit/HBIMKOverlayPathView.h>

@interface HBIMKPolylineView : HBIMKOverlayPathView {
    NSArray *path;
}

- (id)initWithPolyline:(HBIMKPolyline *)polyline;

@property (nonatomic, readonly) HBIMKPolyline *polyline;

@end

