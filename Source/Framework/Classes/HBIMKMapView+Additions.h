//
//  MKMapView+Additions.h
//  MapKit
//
//  Created by Rick Fillion on 7/24/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKMapView.h>

@interface HBIMKMapView (Additions)

- (void)addJavascriptTag:(NSString *)urlString;
- (void)addStylesheetTag:(NSString *)urlString;

// Easy Geocoder
- (void)showAddress:(NSString *)address;

// NSControl
- (void)takeStringValueFrom:(id)sender;

- (void)close;

@end
