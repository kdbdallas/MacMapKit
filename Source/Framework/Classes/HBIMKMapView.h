//
//  MKMapView.h
//  MapKit
//
//  Created by Rick Fillion on 7/11/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <CoreLocation/CoreLocation.h>
#import <HBIMapKit/HBIMKTypes.h>
#import <HBIMapKit/HBIMKGeometry.h>
#import <HBIMapKit/HBIMKOverlay.h>
#import <HBIMapKit/HBIMKAnnotationView.h>

@protocol HBIMKMapViewDelegate;
@class HBIMKUserLocation;
@class HBIMKOverlayView;
@class HBIMKWebView;

@interface HBIMKMapView : NSView <CLLocationManagerDelegate, NSCoding> {    
    id <HBIMKMapViewDelegate> __strong delegate;
    HBIMKMapType mapType;
    HBIMKUserLocation *userLocation;
    BOOL showsUserLocation;
    NSMutableArray *overlays;
    NSMutableArray *annotations;
    NSMutableArray *selectedAnnotations;
    
@private
    HBIMKWebView *webView;
    CLLocationManager *locationManager;
    BOOL hasSetCenterCoordinate;
    // Overlays
    NSMapTable *overlayViews;
    NSMapTable *overlayScriptObjects;
    // Annotations
    NSMapTable *annotationViews;
    NSMapTable *annotationScriptObjects;

    
}
@property (nonatomic, strong) id <HBIMKMapViewDelegate> delegate;

@property(nonatomic) HBIMKMapType mapType;
@property(nonatomic, readonly) HBIMKUserLocation *userLocation;
@property(nonatomic) HBIMKCoordinateRegion region;
@property(nonatomic) CLLocationCoordinate2D centerCoordinate;
@property(nonatomic) BOOL showsUserLocation;
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
@property(nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;
@property(weak, nonatomic, readonly) NSArray *overlays;
@property(weak, nonatomic, readonly) NSArray *annotations;
@property(nonatomic, copy) NSArray *selectedAnnotations;


- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;
- (void)setRegion:(HBIMKCoordinateRegion)region animated:(BOOL)animated;

// Overlays
- (void)addOverlay:(id < HBIMKOverlay >)overlay;
- (void)addOverlays:(NSArray *)overlays;
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;
- (void)insertOverlay:(id < HBIMKOverlay >)overlay aboveOverlay:(id < HBIMKOverlay >)sibling;
- (void)insertOverlay:(id < HBIMKOverlay >)overlay atIndex:(NSUInteger)index;
- (void)insertOverlay:(id < HBIMKOverlay >)overlay belowOverlay:(id < HBIMKOverlay >)sibling;
- (void)removeOverlay:(id < HBIMKOverlay >)overlay;
- (void)removeOverlays:(NSArray *)overlays;
- (HBIMKOverlayView *)viewForOverlay:(id < HBIMKOverlay >)overlay;

// Annotations
- (void)addAnnotation:(id < HBIMKAnnotation >)annotation;
- (void)addAnnotations:(NSArray *)annotations;
- (void)removeAnnotation:(id < HBIMKAnnotation >)annotation;
- (void)removeAnnotations:(NSArray *)annotations;
- (HBIMKAnnotationView *)viewForAnnotation:(id < HBIMKAnnotation >)annotation;
- (HBIMKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;
- (void)selectAnnotation:(id < HBIMKAnnotation >)annotation animated:(BOOL)animated;
- (void)deselectAnnotation:(id < HBIMKAnnotation >)annotation animated:(BOOL)animated;

// Converting Map Coordinates
- (NSPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(NSView *)view;
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(NSView *)view;
- (HBIMKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(NSView *)view;
- (NSRect)convertRegion:(HBIMKCoordinateRegion)region toRectToView:(NSView *)view;

@end


@protocol HBIMKMapViewDelegate <NSObject>
@optional

- (void)mapView:(HBIMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
- (void)mapView:(HBIMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

- (void)mapViewWillStartLoadingMap:(HBIMKMapView *)mapView;
- (void)mapViewDidFinishLoadingMap:(HBIMKMapView *)mapView;
- (void)mapViewDidFailLoadingMap:(HBIMKMapView *)mapView withError:(NSError *)error;

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (HBIMKAnnotationView *)mapView:(HBIMKMapView *)mapView viewForAnnotation:(id <HBIMKAnnotation>)annotation;

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.
- (void)mapView:(HBIMKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

// Overlays
- (HBIMKOverlayView *)mapView:(HBIMKMapView *)mapView viewForOverlay:(id <HBIMKOverlay>)overlay;
- (void)mapView:(HBIMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews;


// iOS 4.0 additions:
- (void)mapView:(HBIMKMapView *)mapView didSelectAnnotationView:(HBIMKAnnotationView *)view;
- (void)mapView:(HBIMKMapView *)mapView didDeselectAnnotationView:(HBIMKAnnotationView *)view;
- (void)mapView:(HBIMKMapView *)mapView didUpdateUserLocation:(HBIMKUserLocation *)userLocation;
- (void)mapView:(HBIMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;
- (void)mapViewWillStartLocatingUser:(HBIMKMapView *)mapView;
- (void)mapViewDidStopLocatingUser:(HBIMKMapView *)mapView;
- (void)mapView:(HBIMKMapView *)mapView annotationView:(HBIMKAnnotationView *)annotationView didChangeDragState:(HBIMKAnnotationViewDragState)newState fromOldState:(HBIMKAnnotationViewDragState)oldState;

// MacMapKit additions
- (void)mapView:(HBIMKMapView *)mapView userDidClickAndHoldAtCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSArray *)mapView:(HBIMKMapView *)mapView contextMenuItemsForAnnotationView:(HBIMKAnnotationView *)view;

@end
