//
//  DemoAppApplicationDelegate.m
//  MapKit
//
//  Created by Rick Fillion on 7/16/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "DemoAppApplicationDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <HBIMapKit/HBIMapKit.h>

@implementation DemoAppApplicationDelegate

@synthesize window;
@synthesize pinTitle;

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    //NSLog(@"applicationDidFinishLaunching:");    
    [mapView setShowsUserLocation: YES];
    [mapView setDelegate: self];
    
    pinNames = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve", nil];

    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 49.8578255;
    coordinate.longitude = -97.16531639999999;
    HBIMKReverseGeocoder *reverseGeocoder = [[HBIMKReverseGeocoder alloc] initWithCoordinate: coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
    
    coreLocationPins = [NSMutableArray array];
    
    HBIMKGeocoder *geocoderNoCoord = [[HBIMKGeocoder alloc] initWithAddress:@"777 Corydon Ave, Winnipeg MB"];
    geocoderNoCoord.delegate = self;
    [geocoderNoCoord start];
    
    HBIMKGeocoder *geocoderCoord = [[HBIMKGeocoder alloc] initWithAddress:@"1250 St. James St" nearCoordinate:coordinate];
    geocoderCoord.delegate = self;
    [geocoderCoord start];
    
}

- (IBAction)setMapType:(id)sender
{
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *)sender;
    [mapView setMapType:[segmentedControl selectedSegment]];
}

- (IBAction)addCircle:(id)sender
{
    HBIMKCircle *circle = [HBIMKCircle circleWithCenterCoordinate:[mapView centerCoordinate] radius:[circleRadius intValue]];
    [mapView addOverlay:circle];
}

- (IBAction)addPin:(id)sender
{
    HBIMKPointAnnotation *pin = [[HBIMKPointAnnotation alloc] init];
    pin.coordinate = [mapView centerCoordinate];
    pin.title = self.pinTitle;
    
    HBIMKCircle *circle = [HBIMKCircle circleWithCenterCoordinate:[mapView centerCoordinate] radius:300];
    
    NSMutableDictionary *coreLocationPin = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            pin, @"pin",
                                            circle, @"circle",
                                            nil];
    
    [coreLocationPins addObject:coreLocationPin];
    
    [mapView addAnnotation:pin];
    [mapView addOverlay:circle];
}

- (IBAction)searchAddress:(id)sender
{
    [mapView showAddress:[addressTextField stringValue]];
}

- (IBAction)demo:(id)sender
{
    for (int i = 0; i<[pinNames count]; i++)
    {
        [self performSelector:@selector(addPinForIndex:) withObject:[NSNumber numberWithInt:i] afterDelay: i * 0.25];
    }
}

- (void)addPinForIndex:(NSNumber *)indexNumber
{
    CLLocationCoordinate2D centerCoordinate = [mapView centerCoordinate];
    NSUInteger total = [pinNames count];
    NSUInteger index = [indexNumber intValue];
    double maxLatOffset = 0.01;
    double maxLngOffset = 0.02;
    NSString *name = [pinNames objectAtIndex:[indexNumber intValue]];

    HBIMKPointAnnotation *pin = [[HBIMKPointAnnotation alloc] init];
    CLLocationCoordinate2D pinCoord = centerCoordinate;
    double latOffset = maxLatOffset * cosf(2*M_PI * ((double)index/(double)total));
    double lngOffset = maxLngOffset * sinf(2*M_PI * ((double)index/(double)total));
    pinCoord.latitude += latOffset;
    pinCoord.longitude += lngOffset;
    pin.coordinate = pinCoord;
    pin.title = name;
    [mapView addAnnotation:pin];

}

- (IBAction)addAdditionalCSS:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MapViewAdditions" ofType:@"css"];
    [mapView performSelector:@selector(addStylesheetTag:) withObject:path afterDelay:1.0];
}

#pragma mark HBIMKReverseGeocoderDelegate

- (void)reverseGeocoder:(HBIMKReverseGeocoder *)geocoder didFindPlacemark:(HBIMKPlacemark *)placemark
{
    //NSLog(@"found placemark: %@", placemark);
}

- (void)reverseGeocoder:(HBIMKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"HBIMKReverseGeocoder didFailWithError: %@", error);
}

#pragma mark HBIMKGeocoderDelegate

- (void)geocoder:(HBIMKGeocoder *)geocoder didFindCoordinate:(CLLocationCoordinate2D)coordinate
{
    //NSLog(@"HBIMKGeocoder found (%f, %f) for %@", coordinate.latitude, coordinate.longitude, geocoder.address);
}

- (void)geocoder:(HBIMKGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"HBIMKGeocoder didFailWithError: %@", error);
}

#pragma mark MapView Delegate

// Responding to Map Position Changes

- (void)mapView:(HBIMKMapView *)aMapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"mapView: %@ regionWillChangeAnimated: %d", aMapView, animated);
}

- (void)mapView:(HBIMKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"mapView: %@ regionDidChangeAnimated: %d", aMapView, animated);
}

//Loading the Map Data
- (void)mapViewWillStartLoadingMap:(HBIMKMapView *)aMapView
{
    //NSLog(@"mapViewWillStartLoadingMap: %@", aMapView);
}

- (void)mapViewDidFinishLoadingMap:(HBIMKMapView *)aMapView
{
    //NSLog(@"mapViewDidFinishLoadingMap: %@", aMapView);
}

- (void)mapViewDidFailLoadingMap:(HBIMKMapView *)aMapView withError:(NSError *)error
{
    //NSLog(@"mapViewDidFailLoadingMap: %@ withError: %@", aMapView, error);
}

// Tracking the User Location
- (void)mapViewWillStartLocatingUser:(HBIMKMapView *)aMapView
{
    //NSLog(@"mapViewWillStartLocatingUser: %@", aMapView);
}

- (void)mapViewDidStopLocatingUser:(HBIMKMapView *)aMapView
{
    //NSLog(@"mapViewDidStopLocatingUser: %@", aMapView);
}

- (void)mapView:(HBIMKMapView *)aMapView didUpdateUserLocation:(HBIMKUserLocation *)userLocation
{
    //NSLog(@"mapView: %@ didUpdateUserLocation: %@", aMapView, userLocation); 
}

- (void)mapView:(HBIMKMapView *)aMapView didFailToLocateUserWithError:(NSError *)error
{
    // NSLog(@"mapView: %@ didFailToLocateUserWithError: %@", aMapView, error);
}

// Managing Annotation Views


- (HBIMKAnnotationView *)mapView:(HBIMKMapView *)aMapView viewForAnnotation:(id <HBIMKAnnotation>)annotation
{
    //NSLog(@"mapView: %@ viewForAnnotation: %@", aMapView, annotation);
    //HBIMKAnnotationView *view = [[[HBIMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"blah"] autorelease];
    HBIMKPinAnnotationView *view = [[HBIMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"blah"];
    view.draggable = YES;
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"MarkerTest" ofType:@"png"];
    //NSURL *url = [NSURL fileURLWithPath:path];
    //view.imageUrl = [url absoluteString];
    return view;
}
 
- (void)mapView:(HBIMKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    //NSLog(@"mapView: %@ didAddAnnotationViews: %@", aMapView, views);
}
 /*
 - (void)mapView:(MKMapView *)aMapView annotationView:(HBIMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
 {
 NSLog(@"mapView: %@ annotationView: %@ calloutAccessoryControlTapped: %@", aMapView, view, control);
 }
 */

// Dragging an Annotation View
/*
 - (void)mapView:(HBIMKMapView *)aMapView annotationView:(HBIMKAnnotationView *)annotationView 
 didChangeDragState:(HBIMKAnnotationViewDragState)newState 
 fromOldState:(HBIMKAnnotationViewDragState)oldState
 {
 NSLog(@"mapView: %@ annotationView: %@ didChangeDragState: %d fromOldState: %d", aMapView, annotationView, newState, oldState);
 }
 */


// Selecting Annotation Views

- (void)mapView:(HBIMKMapView *)aMapView didSelectAnnotationView:(HBIMKAnnotationView *)view
{
    //NSLog(@"mapView: %@ didSelectAnnotationView: %@", aMapView, view);
}

- (void)mapView:(HBIMKMapView *)aMapView didDeselectAnnotationView:(HBIMKAnnotationView *)view
{
    //NSLog(@"mapView: %@ didDeselectAnnotationView: %@", aMapView, view);
}


// Managing Overlay Views

- (HBIMKOverlayView *)mapView:(HBIMKMapView *)aMapView viewForOverlay:(id <HBIMKOverlay>)overlay
{
    //NSLog(@"mapView: %@ viewForOverlay: %@", aMapView, overlay);
    HBIMKCircleView *circleView = [[HBIMKCircleView alloc] initWithCircle:overlay];
    return circleView;
    //    HBIMKPolylineView *polylineView = [[[HBIMKPolylineView alloc] initWithPolyline:overlay] autorelease];
    //    return polylineView;
    HBIMKPolygonView *polygonView = [[HBIMKPolygonView alloc] initWithPolygon:overlay];
    return polygonView;
}

- (void)mapView:(HBIMKMapView *)aMapView didAddOverlayViews:(NSArray *)overlayViews
{
    //NSLog(@"mapView: %@ didAddOverlayViews: %@", aMapView, overlayViews);
}

- (void)mapView:(HBIMKMapView *)aMapView annotationView:(HBIMKAnnotationView *)annotationView didChangeDragState:(HBIMKAnnotationViewDragState)newState fromOldState:(HBIMKAnnotationViewDragState)oldState
{
    //NSLog(@"mapView: %@ annotationView: %@ didChangeDragState:%d fromOldState:%d", aMapView, annotationView, newState, oldState);
    
    if (newState ==  HBIMKAnnotationViewDragStateEnding || newState == HBIMKAnnotationViewDragStateNone)
    {
        // create a new circle view
        HBIMKPointAnnotation *pinAnnotation = annotationView.annotation;
        for (NSMutableDictionary *pin in coreLocationPins)
        {
            if ([[pin objectForKey:@"pin"] isEqual: pinAnnotation])
            {
                // found the pin.
                HBIMKCircle *circle = [pin objectForKey:@"circle"];
                CLLocationDistance pinCircleRadius = circle.radius;
                [aMapView removeOverlay:circle];
                
                circle = [HBIMKCircle circleWithCenterCoordinate:pinAnnotation.coordinate radius:pinCircleRadius];
                [pin setObject:circle forKey:@"circle"];
                [aMapView addOverlay:circle];
            }
        }
    }
    else {
        // find old circle view and remove it
        HBIMKPointAnnotation *pinAnnotation = annotationView.annotation;
        for (NSMutableDictionary *pin in coreLocationPins)
        {
            if ([[pin objectForKey:@"pin"] isEqual: pinAnnotation])
            {
                // found the pin.
                HBIMKCircle *circle = [pin objectForKey:@"circle"];
                [aMapView removeOverlay:circle];
            }
        }
    }

    
    //HBIMKPointAnnotation *annotation = annotationView.annotation;
    //NSLog(@"annotation = %@", annotation);
    
}

// MacMapKit additions
- (void)mapView:(HBIMKMapView *)aMapView userDidClickAndHoldAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    //NSLog(@"mapView: %@ userDidClickAndHoldAtCoordinate: (%f, %f)", aMapView, coordinate.latitude, coordinate.longitude);
    HBIMKPointAnnotation *pin = [[HBIMKPointAnnotation alloc] init];
    pin.coordinate = coordinate;
    pin.title = @"Hi.";
    [mapView addAnnotation:pin];
}

- (NSArray *)mapView:(HBIMKMapView *)mapView contextMenuItemsForAnnotationView:(HBIMKAnnotationView *)view
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Delete It" action:@selector(delete:) keyEquivalent:@""];
    return [NSArray arrayWithObject:item];
}


@end
