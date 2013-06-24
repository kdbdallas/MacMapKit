//
//  DemoAppApplicationDelegate.h
//  MapKit
//
//  Created by Rick Fillion on 7/16/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMapKit.h>

@class HBIMKMapView;

@interface DemoAppApplicationDelegate : NSObject <NSApplicationDelegate, HBIMKMapViewDelegate, HBIMKReverseGeocoderDelegate, HBIMKGeocoderDelegate> {
    NSWindow *__strong window;
    IBOutlet HBIMKMapView *mapView;
    IBOutlet NSTextField *addressTextField;
    NSNumber *circleRadius;
    NSString *pinTitle;
    NSArray *pinNames;
    
    NSMutableArray *coreLocationPins;
}

@property (strong) IBOutlet NSWindow *window;
@property (strong) NSString *pinTitle;

- (IBAction)setMapType:(id)sender;
- (IBAction)addCircle:(id)sender;
- (IBAction)addPin:(id)sender;
- (IBAction)searchAddress:(id)sender;
- (IBAction)demo:(id)sender;
- (IBAction)addAdditionalCSS:(id)sender;

@end
