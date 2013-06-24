//
//  MKOverlayView.m
//  MapKit
//
//  Created by Rick Fillion on 7/12/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKOverlayView.h"

@implementation HBIMKOverlayView

@synthesize overlay;

- (id)initWithOverlay:(id <HBIMKOverlay>)anOverlay
{
    if (self = [super init])
    {
        overlay = [anOverlay retain];
    }
    return self;
}


- (void)dealloc
{
    [overlay release];
    [super dealloc];
}



@end
