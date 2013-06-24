//
//  MKPinAnnotationView.m
//  MapKit
//
//  Created by Rick Fillion on 7/18/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKPinAnnotationView.h"


@implementation HBIMKPinAnnotationView

@synthesize pinColor;
@synthesize animatesDrop;

- (id)initWithAnnotation:(id <HBIMKAnnotation>)anAnnotation reuseIdentifier:(NSString *)aReuseIdentifier
{
    if (self = [super initWithAnnotation:anAnnotation reuseIdentifier:aReuseIdentifier])
    {
        self.canShowCallout = YES;
    }
    return self;
}

- (NSString *)imageUrl
{
    NSBundle *bundle = [NSBundle bundleForClass:[HBIMKPinAnnotationView class]];
    NSString *filename = nil;
    switch (pinColor) {
        case HBIMKPinAnnotationColorRed:
            filename = @"HBIMKPinAnnotationColorRed";
            break;
        case HBIMKPinAnnotationColorGreen:
            filename = @"MKPinAnnotationColorGreen";
            break;
        case HBIMKPinAnnotationColorPurple:
            filename = @"HBIMKPinAnnotationColorPurple";
            break;
        default:
            filename = @"HBIMKPinAnnotationColorRed";
            break;
    }
    NSString *path = [bundle pathForResource:filename ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:path];
    return [url absoluteString];
}

@end
