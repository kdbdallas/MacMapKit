//
//  MKMapView+DelegateWrappers.h
//  MapKit
//
//  Created by Rick Fillion on 7/22/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKMapView.h>

@interface HBIMKMapView (DelegateWrappers)

// Map Position Changes
- (void)delegateRegionWillChangeAnimated:(BOOL)animated;
- (void)delegateRegionDidChangeAnimated:(BOOL)animated;

// Loading the Map Data
- (void)delegateWillStartLoadingMap;
- (void)delegateDidFinishLoadingMap;
- (void)delegateDidFailLoadingMapWithError:(NSError *)error;

// Tracking the User Location
- (void)delegateDidUpdateUserLocation;
- (void)delegateDidFailToLocateUserWithError:(NSError *)error;
- (void)delegateWillStartLocatingUser;
- (void)delegateDidStopLocatingUser;

// Managing Annotation Views
- (void)delegateDidAddAnnotationViews:(NSArray *)annotationViews;

// Dragging an Annotation View
- (void)delegateAnnotationView:(HBIMKAnnotationView *)annotationView didChangeDragState:(HBIMKAnnotationViewDragState)newState fromOldState:(HBIMKAnnotationViewDragState)oldState;

// Selecting Annotation Views
- (void)delegateDidSelectAnnotationView:(HBIMKAnnotationView *)view;
- (void)delegateDidDeselectAnnotationView:(HBIMKAnnotationView *)view;

// Managing Overlay Views
- (void)delegateDidAddOverlayViews:(NSArray *)overlayViews;

// MacMapKit additions
- (void)delegateUserDidClickAndHoldAtCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSArray *)delegateContextMenuItemsForAnnotationView:(HBIMKAnnotationView *)view;

@end
