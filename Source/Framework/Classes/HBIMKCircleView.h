//
//  MKCircleView.h
//  MapKit
//
//  Created by Rick Fillion on 7/12/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKOverlayPathView.h>

@class HBIMKCircle;

@interface HBIMKCircleView : HBIMKOverlayPathView {
    WebScriptObject *latlngCenter;
}

@property (nonatomic, readonly) HBIMKCircle *circle;

- (id)initWithCircle:(HBIMKCircle *)circle;



@end
