//
//  MKMapView.m
//  MapKit
//
//  Created by Rick Fillion on 7/11/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKMapView.h"
#import "HBIMKMapView+Private.h"
#import "JSON.h"
#import <HBIMapKit/HBIMKUserLocation.h>
#import <HBIMapKit/HBIMKCircleView.h>
#import <HBIMapKit/HBIMKCircle.h>
#import <HBIMapKit/HBIMKPolyline.h>
#import <HBIMapKit/HBIMKPolygon.h>
#import <HBIMapKit/HBIMKAnnotationView.h>
#import <HBIMapKit/HBIMKPointAnnotation.h>
#import "HBIMKMapView+DelegateWrappers.h"
#import "HBIMKMapView+WebViewIntegration.h"
#import "HBIMKWebView.h"


@implementation HBIMKMapView

@synthesize delegate, mapType, userLocation, showsUserLocation;


- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) 
    {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder])
    {
        [self customInit];
        [self setMapType:[decoder decodeIntegerForKey:@"mapType"]];
        [self setShowsUserLocation:[decoder decodeBoolForKey:@"showsUserLocation"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    //[encoder encodeObject:webView forKey:@"webView"];
    [encoder encodeInteger:[self mapType] forKey:@"mapType"];
    [encoder encodeBool:[self showsUserLocation] forKey:@"showsUserLocation"];
}

- (void)dealloc
{
    [webView close];
    [webView setFrameLoadDelegate:nil];
    [webView removeFromSuperview];
    [locationManager stopUpdatingLocation];
}

- (void)setFrame:(NSRect)frameRect
{
    [self delegateRegionWillChangeAnimated:NO];
    [super setFrame:frameRect];
    [self willChangeValueForKey:@"region"];
    [self didChangeValueForKey:@"region"];
    [self willChangeValueForKey:@"centerCoordinate"];
    [self didChangeValueForKey:@"centerCoordinate"];
    [self delegateRegionDidChangeAnimated:NO];
}

- (void)setMapType:(HBIMKMapType)type
{
    mapType = type;
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    NSArray *args = [NSArray arrayWithObject:[NSNumber numberWithInt:mapType]];
    [webScriptObject callWebScriptMethod:@"setMapType" withArguments:args];
}

- (CLLocationCoordinate2D)centerCoordinate
{
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    NSNumber *latitude = nil; 
    NSNumber *longitude = nil;
    NSString *json = [webScriptObject evaluateWebScript:@"getCenterCoordinate()"];
    if ([json isKindOfClass:[NSString class]])
    {
        NSDictionary *latlong = [json JSONValue];
        latitude = [latlong objectForKey:@"latitude"];
        longitude = [latlong objectForKey:@"longitude"];
    }

    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = [latitude doubleValue];
    centerCoordinate.longitude = [longitude doubleValue];
    return centerCoordinate;
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self setCenterCoordinate:coordinate animated: NO];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    [self willChangeValueForKey:@"region"];
    NSArray *args = [NSArray arrayWithObjects:
                     [NSNumber numberWithDouble:coordinate.latitude],
                     [NSNumber numberWithDouble:coordinate.longitude],
                     [NSNumber numberWithBool:animated], 
                      nil];
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    [webScriptObject callWebScriptMethod:@"setCenterCoordinateAnimated" withArguments:args];
    [self didChangeValueForKey:@"region"];
    hasSetCenterCoordinate = YES;
}


- (HBIMKCoordinateRegion)region
{
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    NSString *json = [webScriptObject evaluateWebScript:@"getRegion()"];
    NSDictionary *regionDict = [json JSONValue];
    
    NSNumber *centerLatitude = [regionDict valueForKeyPath:@"center.latitude"];
    NSNumber *centerLongitude = [regionDict valueForKeyPath:@"center.longitude"];
    NSNumber *latitudeDelta = [regionDict objectForKey:@"latitudeDelta"];
    NSNumber *longitudeDelta = [regionDict objectForKey:@"longitudeDelta"];
    
    HBIMKCoordinateRegion region;
    region.center.longitude = [centerLongitude doubleValue];
    region.center.latitude = [centerLatitude doubleValue];
    region.span.latitudeDelta = [latitudeDelta doubleValue];
    region.span.longitudeDelta = [longitudeDelta doubleValue];
    return region;
}

- (void)setRegion:(HBIMKCoordinateRegion)region
{
    [self setRegion:region animated: NO];
}

- (void)setRegion:(HBIMKCoordinateRegion)region animated:(BOOL)animated
{
    [self delegateRegionWillChangeAnimated:animated];
    [self willChangeValueForKey:@"centerCoordinate"];
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    NSArray *args = [NSArray arrayWithObjects:
                     [NSNumber numberWithDouble:region.center.latitude], 
                     [NSNumber numberWithDouble:region.center.longitude], 
                     [NSNumber numberWithDouble:region.span.latitudeDelta], 
                     [NSNumber numberWithDouble:region.span.longitudeDelta],
                     [NSNumber numberWithBool:animated], 
                     nil];
    [webScriptObject callWebScriptMethod:@"setRegionAnimated" withArguments:args];
    [self didChangeValueForKey:@"centerCoordinate"];
    [self delegateRegionDidChangeAnimated:animated];
}

- (void)setShowsUserLocation:(BOOL)show
{
    BOOL oldValue = showsUserLocation;
    showsUserLocation = show;
    
    if (oldValue == NO && showsUserLocation == YES)
    {
		[self delegateWillStartLocatingUser];
		// To be sure we get all of the delegate calls from CoreLocation, we have to recreate the manager.
		// Unfortunately if you just call stop/start, it'll never resend the kCLErrorDenied error.
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    
    if (showsUserLocation)
    {
        [userLocation _setUpdating:YES];
        [locationManager startUpdatingLocation];
    }
    else 
    {
        [self setUserLocationMarkerVisible: NO];
        [userLocation _setUpdating:NO];
        [locationManager stopUpdatingLocation];
		locationManager = nil;
        [userLocation _setLocation:nil];
    }
    
    if (oldValue == YES && showsUserLocation == NO)
    {
		[self delegateDidStopLocatingUser];
    }
}

- (BOOL)isUserLocationVisible
{
    if (!self.showsUserLocation || !userLocation.location)
        return NO;
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    NSNumber *visible = [webScriptObject callWebScriptMethod:@"isUserLocationVisible" withArguments:[NSArray array]];
    return [visible boolValue];
}

#pragma mark Overlays

- (NSArray *)overlays
{
    return [overlays copy];
}

- (void)addOverlay:(id < HBIMKOverlay >)overlay
{
    [self insertOverlay:overlay atIndex:[overlays count]];
}

- (void)addOverlays:(NSArray *)someOverlays
{
    for (id<HBIMKOverlay>overlay in someOverlays)
    {
        [self addOverlay: overlay];
    }
}

- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2
{
    if (index1 >= [overlays count] || index2 >= [overlays count])
    {
        NSLog(@"exchangeOverlayAtIndex: either index1 or index2 is above the bounds of the overlays array.");
        return;
    }
    
    id < HBIMKOverlay > overlay1 = [overlays objectAtIndex: index1];
    id < HBIMKOverlay > overlay2 = [overlays objectAtIndex: index2];
    [overlays replaceObjectAtIndex:index2 withObject:overlay1];
    [overlays replaceObjectAtIndex:index1 withObject:overlay2];
    [self updateOverlayZIndexes];
}

- (void)insertOverlay:(id < HBIMKOverlay >)overlay aboveOverlay:(id < HBIMKOverlay >)sibling
{
    if (![overlays containsObject:sibling])
        return;
    
    NSUInteger indexOfSibling = [overlays indexOfObject:sibling];
    [self insertOverlay:overlay atIndex: indexOfSibling+1];
}

- (void)insertOverlay:(id < HBIMKOverlay >)overlay atIndex:(NSUInteger)index
{
    // check if maybe we already have this one.
    if ([overlays containsObject:overlay])
        return;
    
    // Make sure we have a valid index.
    if (index > [overlays count])
        index = [overlays count];
    
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    if ([webScriptObject isKindOfClass:[WebUndefined class]])
    {
	NSLog(@"MapKit view isn't ready to add overlay: %@", overlay);
	return;
    }
    
    HBIMKOverlayView *overlayView = nil;
    if ([self.delegate respondsToSelector:@selector(mapView:viewForOverlay:)])
        overlayView = [self.delegate mapView:self viewForOverlay:overlay];
    if (!overlayView)
    {
        // TODO: Handle the case where we have no view
        NSLog(@"Wasn't able to create a MKOverlayView for overlay: %@", overlay);
        return;
    }
    
    WebScriptObject *overlayScriptObject = [overlayView overlayScriptObjectFromMapScriptObject:webScriptObject];
    if (![overlayScriptObject isKindOfClass:[WebScriptObject class]])
    {
	NSLog(@"Error creating internal representation of overlay view for overlay: %@", overlay);
	return;
    }
    
    [overlays insertObject:overlay atIndex:index];
    [overlayViews setObject:overlayView forKey:overlay];
    [overlayScriptObjects setObject:overlayScriptObject forKey:overlay];
        
    NSArray *args = [NSArray arrayWithObject:overlayScriptObject];
    [webScriptObject callWebScriptMethod:@"addOverlay" withArguments:args];
    [overlayView draw:overlayScriptObject];
    
    [self updateOverlayZIndexes];
    
    // TODO: refactor how this works so that we can send one batch call
    // when they called addOverlays:
    [self delegateDidAddOverlayViews:[NSArray arrayWithObject:overlayView]];
}

- (void)insertOverlay:(id < HBIMKOverlay >)overlay belowOverlay:(id < HBIMKOverlay >)sibling
{
    if (![overlays containsObject:sibling])
        return;
    
    NSUInteger indexOfSibling = [overlays indexOfObject:sibling];
    [self insertOverlay:overlay atIndex: indexOfSibling];    
}

- (void)removeOverlay:(id < HBIMKOverlay >)overlay
{
    if (![overlays containsObject:overlay])
        return;
    
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    WebScriptObject *overlayScriptObject = (WebScriptObject *)[overlayScriptObjects objectForKey: overlay];
    NSArray *args = [NSArray arrayWithObject:overlayScriptObject];
    [webScriptObject callWebScriptMethod:@"removeOverlay" withArguments:args];

    [overlayViews removeObjectForKey:overlay];
    [overlayScriptObjects removeObjectForKey:overlay];
    
    [overlays removeObject:overlay];
    [self updateOverlayZIndexes];
}

- (void)removeOverlays:(NSArray *)someOverlays
{
    for (id<HBIMKOverlay>overlay in someOverlays)
    {
        [self removeOverlay: overlay];
    }
}

- (HBIMKOverlayView *)viewForOverlay:(id < HBIMKOverlay >)overlay
{
    if (![overlays containsObject:overlay])
        return nil;
    return (HBIMKOverlayView *)[overlayViews objectForKey: overlay];
}

#pragma mark Annotations

- (NSArray *)annotations
{
    return [annotations copy];
}

- (void)addAnnotation:(id < HBIMKAnnotation >)annotation
{
    // check if maybe we already have this one.
    if ([annotations containsObject:annotation])
        return;
    
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    if ([webScriptObject isKindOfClass:[WebUndefined class]])
    {
	NSLog(@"MapKit view isn't ready to add annotation: %@", annotation);
	return;
    }
    
    HBIMKAnnotationView *annotationView = nil;
    if ([self.delegate respondsToSelector:@selector(mapView:viewForAnnotation:)])
        annotationView = [self.delegate mapView:self viewForAnnotation:annotation];
    if (!annotationView)
    {
        // TODO: Handle the case where we have no view
        NSLog(@"Wasn't able to create a MKAnnotationView for annotation: %@", annotation);
        return;
    }
    
    WebScriptObject *annotationScriptObject = [annotationView overlayScriptObjectFromMapScriptObject:webScriptObject];
    if (![annotationScriptObject isKindOfClass:[WebScriptObject class]])
    {
	NSLog(@"Error creating internal representation of annotation view for annotation: %@", annotation);
	return;
    }
    
    [annotations addObject:annotation];
    [annotationViews setObject:annotationView forKey:annotation];
    [annotationScriptObjects setObject:annotationScriptObject forKey:annotation];
    
    NSArray *args = [NSArray arrayWithObject:annotationScriptObject];
    [webScriptObject callWebScriptMethod:@"addAnnotation" withArguments:args];
    [annotationView draw:annotationScriptObject];
    
    [self updateAnnotationZIndexes];
    
    // TODO: refactor how this works so that we can send one batch call
    // when they called addAnnotations:
    [self delegateDidAddAnnotationViews:[NSArray arrayWithObject:annotationView]];
}

- (void)addAnnotations:(NSArray *)someAnnotations
{
    for (id<HBIMKAnnotation>annotation in someAnnotations)
    {
        [self addAnnotation: annotation];
    }
}

- (void)removeAnnotation:(id < HBIMKAnnotation >)annotation
{
    if (![annotations containsObject:annotation])
        return;
    
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    WebScriptObject *annotationScriptObject = (WebScriptObject *)[annotationScriptObjects objectForKey: annotation];
    NSArray *args = [NSArray arrayWithObject:annotationScriptObject];
    [webScriptObject callWebScriptMethod:@"removeAnnotation" withArguments:args];
    
    [annotationViews removeObjectForKey: annotation];
    [annotationScriptObjects removeObjectForKey: annotation];
    
    [annotations removeObject:annotation];
}

- (void)removeAnnotations:(NSArray *)someAnnotations
{
    for (id<HBIMKAnnotation>annotation in someAnnotations)
    {
        [self removeAnnotation: annotation];
    }
}

- (HBIMKAnnotationView *)viewForAnnotation:(id < HBIMKAnnotation >)annotation
{
    if (![annotations containsObject:annotation])
        return nil;
    return (HBIMKAnnotationView *)[annotationViews objectForKey: annotation];
}

- (HBIMKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier
{
    // Unsupported for now.
    return nil; 
}

- (void)selectAnnotation:(id < HBIMKAnnotation >)annotation animated:(BOOL)animated
{
    if ([selectedAnnotations containsObject:annotation])
        return;

    HBIMKAnnotationView *annotationView = (id)[annotationViews objectForKey: annotation];
    [selectedAnnotations addObject:annotation];
    [self delegateDidSelectAnnotationView:annotationView];
    
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    WebScriptObject *annotationScriptObject = (WebScriptObject *)[annotationScriptObjects objectForKey: annotation];

    if (annotation.title && annotationView.canShowCallout)
    {
        NSArray *args = [NSArray arrayWithObjects:annotationScriptObject, annotation.title, nil];
        [webScriptObject callWebScriptMethod:@"setAnnotationCalloutText" withArguments:args];
        args = [NSArray arrayWithObjects:annotationScriptObject, [NSNumber numberWithBool:NO], nil];
        [webScriptObject callWebScriptMethod:@"setAnnotationCalloutHidden" withArguments:args];
    }

}

- (void)deselectAnnotation:(id < HBIMKAnnotation >)annotation animated:(BOOL)animated
{
// TODO : animate this if called for.
    if (![selectedAnnotations containsObject:annotation])
        return;

    HBIMKAnnotationView *annotationView = (id)[annotationViews objectForKey: annotation];
    [selectedAnnotations removeObject:annotation];
    [self delegateDidDeselectAnnotationView:annotationView];

    WebScriptObject *webScriptObject = [webView windowScriptObject];
    WebScriptObject *annotationScriptObject = (WebScriptObject *)[annotationScriptObjects objectForKey: annotation];
    
    NSArray *args = [NSArray arrayWithObjects:annotationScriptObject, [NSNumber numberWithBool:YES], nil];
    [webScriptObject callWebScriptMethod:@"setAnnotationCalloutHidden" withArguments:args];
}

- (NSArray *)selectedAnnotations
{
    return [selectedAnnotations copy];
}

- (void)setSelectedAnnotations:(NSArray *)someAnnotations
{
    // Deselect whatever was selected
    NSArray *oldSelectedAnnotations = [self selectedAnnotations];
    for (id <HBIMKAnnotation> annotation in oldSelectedAnnotations)
    {
        [self deselectAnnotation:annotation animated:NO];
    }
    NSMutableArray *newSelectedAnnotations = [NSMutableArray arrayWithArray: [someAnnotations copy]];
    selectedAnnotations = newSelectedAnnotations;
    
    // If it's manually set and there's more than one, you only select the first according to the docs.
    if ([selectedAnnotations count] > 0)
        [self selectAnnotation:[selectedAnnotations objectAtIndex:0] animated:NO];
}

#pragma mark Converting Map Coordinates

- (NSPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(NSView *)view
{
    NSPoint point = {0,0};
    NSArray *args = [NSArray arrayWithObjects:
                     [NSNumber numberWithDouble:coordinate.latitude],
                     [NSNumber numberWithDouble:coordinate.longitude],
		     nil];
    WebScriptObject *webScriptObject = [webView windowScriptObject];
    NSString *json = [webScriptObject callWebScriptMethod:@"convertCoordinate" withArguments:args];
    NSNumber *x = nil; 
    NSNumber *y = nil;
    if ([json isKindOfClass:[NSString class]])
    {
        NSDictionary *xy = [json JSONValue];
        x = [xy objectForKey:@"x"];
        y = [xy objectForKey:@"y"];
    }
    
    point.x = [x integerValue];
    point.y = [y integerValue];
    
    point = [webView convertPoint:point toView:view];
    
    return point;
}

- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(NSView *)view
{
// TODO: Implement
    NSLog(@"-[HBIMKMapView convertPoint: toCoordinateFromView:] not implemented yet");
    CLLocationCoordinate2D coordinate;
    
    return coordinate;
}

- (HBIMKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(NSView *)view
{
// TODO: Implement
    NSLog(@"-[HBIMKMapView convertRect: toRegionFromView:] not implemented yet");
    HBIMKCoordinateRegion region;
    
    return region;
}

- (NSRect)convertRegion:(HBIMKCoordinateRegion)region toRectToView:(NSView *)view
{
// TODO: Implement
    NSLog(@"-[HBIMKMapView convertRegion: toRectToView:] not implemented yet");
    return NSZeroRect;
}

#pragma mark Faked Properties

- (BOOL)isScrollEnabled
{
    return YES;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (!scrollEnabled)
        NSLog(@"setting scrollEnabled to NO on MKMapView not supported.");
}

- (BOOL)isZoomEnabled
{
    return YES;
}

- (void)setZoomEnabled:(BOOL)zoomEnabled
{
    if (!zoomEnabled)
        NSLog(@"setting zoomEnabled to NO on MKMapView not supported");
}



#pragma mark CoreLocationManagerDelegate

- (void) locationManager: (CLLocationManager *)manager
     didUpdateToLocation: (CLLocation *)newLocation
            fromLocation: (CLLocation *)oldLocation
{
    if (!hasSetCenterCoordinate)
        [self setCenterCoordinate:newLocation.coordinate];
    [userLocation _setLocation:newLocation];
    [self updateUserLocationMarkerWithLocaton:newLocation];
    [self setUserLocationMarkerVisible:YES];
    [self delegateDidUpdateUserLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self delegateDidFailToLocateUserWithError:error];
    [self setUserLocationMarkerVisible:NO];
    
    if ([error code] == kCLErrorDenied)
    {
	[self setShowsUserLocation:NO];
    }
}

#pragma mark WebFrameLoadDelegate

- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowScriptObject forFrame:(WebFrame *)frame
{
    [windowScriptObject setValue:windowScriptObject forKey:@"WindowScriptObject"];
    [windowScriptObject setValue:self forKey:@"HBIMKMapView"];
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if ([frame isEqual:[webView mainFrame]])
        [self delegateWillStartLoadingMap];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if ([frame isEqual:[webView mainFrame]])
        [self delegateDidFailLoadingMapWithError:error];
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if ([frame isEqual:[webView mainFrame]])
        [self delegateDidFailLoadingMapWithError:error];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    // CoreLocation can sometimes trigger before the page has even finished loading.
    if (self.showsUserLocation && userLocation.location)
    {
        [self locationManager: locationManager didUpdateToLocation: userLocation.location fromLocation:nil];
    }
    
    if ([frame isEqual:[webView mainFrame]])
    {
        // In case we have to resume state from NSCoding
        [self setMapType:[self mapType]];
        [self setShowsUserLocation:[self showsUserLocation]];
        
	[self performSelector:@selector(delegateDidFinishLoadingMap) withObject:nil afterDelay:0.5];
    }
}

#pragma mark WebUIDelegate

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{
    return [NSArray array];
}

- (NSUInteger)webView:(WebView *)sender dragDestinationActionMaskForDraggingInfo:(id <NSDraggingInfo>)draggingInfo
{
    return WebDragDestinationActionNone;
}

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSLog(@"alert: %@", message);
}

@end
