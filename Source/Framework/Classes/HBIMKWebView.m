//
//  MKWebView.m
//  MapKit
//
//  Created by Rick Fillion on 10-12-12.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKWebView.h"


@implementation HBIMKWebView

@synthesize lastHitTestDate;


- (NSView *)hitTest:(NSPoint)aPoint
{
    //NSLog(@"hitTest: %@", NSStringFromPoint(aPoint));
    lastHitTestDate = [NSDate date];
    return [super hitTest:aPoint];
}

@end
