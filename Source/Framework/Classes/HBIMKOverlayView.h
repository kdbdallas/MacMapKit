//
//  MKOverlayView.h
//  MapKit
//
//  Created by Rick Fillion on 7/12/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKOverlay.h>
#import <HBIMapKit/HBIMKView.h>

@interface HBIMKOverlayView : HBIMKView {
    id <HBIMKOverlay> __unsafe_unretained overlay;
}

@property (unsafe_unretained, nonatomic, readonly) id <HBIMKOverlay> overlay;


- (id)initWithOverlay:(id <HBIMKOverlay>)anOverlay;


@end
