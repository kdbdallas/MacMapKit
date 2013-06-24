//
//  MKPolygonView.h
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKPolygon.h>
#import <HBIMapKit/HBIMKOverlayPathView.h>

@interface HBIMKPolygonView : HBIMKOverlayPathView{
    NSArray *path;
    NSArray *interiorPaths;
}

- (id)initWithPolygon:(HBIMKPolygon *)polygon;

@property (weak, nonatomic, readonly) HBIMKPolygon *polygon;

@end

