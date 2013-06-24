//
//  MKPinAnnotationView.h
//  MapKit
//
//  Created by Rick Fillion on 7/18/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKAnnotationView.h>

enum {
    HBIMKPinAnnotationColorRed = 0,
    HBIMKPinAnnotationColorGreen,
    HBIMKPinAnnotationColorPurple
};
typedef NSUInteger HBIMKPinAnnotationColor;


@interface HBIMKPinAnnotationView : HBIMKAnnotationView
{
    HBIMKPinAnnotationColor pinColor;
    BOOL animatesDrop;
}

@property (nonatomic) HBIMKPinAnnotationColor pinColor;
@property (nonatomic) BOOL animatesDrop;

@end

