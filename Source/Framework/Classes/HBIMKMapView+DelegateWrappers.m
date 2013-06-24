//
//  MKMapView+DelegateWrappers.m
//  MapKit
//
//  Created by Rick Fillion on 7/22/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKMapView+DelegateWrappers.h"


@implementation HBIMKMapView (DelegateWrappers)

- (void)delegateRegionWillChangeAnimated:(BOOL)animated
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:regionWillChangeAnimated:)])
    {
        [delegate mapView:self regionWillChangeAnimated:animated];
    }
}

- (void)delegateRegionDidChangeAnimated:(BOOL)animated
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)])
    {
        [delegate mapView:self regionDidChangeAnimated:animated];
    }
}

- (void)delegateDidUpdateUserLocation
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)])
    {
        [delegate mapView:self didUpdateUserLocation:userLocation];
    }
}

- (void)delegateDidFailToLocateUserWithError:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)])
    {
        [delegate mapView:self didFailToLocateUserWithError:error];
    }
}

- (void)delegateWillStartLocatingUser
{
    if (delegate && [delegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)])
    {
        [delegate mapViewWillStartLocatingUser:self];
    }
}

- (void)delegateDidStopLocatingUser
{
    if (delegate && [delegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)])
    {
        [delegate mapViewDidStopLocatingUser:self];
    }
}

- (void)delegateDidAddOverlayViews:(NSArray *)someOverlayViews
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:didAddOverlayViews:)])
    {
        [delegate mapView:self didAddOverlayViews:someOverlayViews];
    }
}

- (void)delegateDidAddAnnotationViews:(NSArray *)someAnnotationViews
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:didAddAnnotationViews:)])
    {
        [delegate mapView:self didAddAnnotationViews:someAnnotationViews];
    }
}

- (void)delegateDidSelectAnnotationView:(HBIMKAnnotationView *)view
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)])
    {
        [delegate mapView:self didSelectAnnotationView:view];
    }
}

- (void)delegateDidDeselectAnnotationView:(HBIMKAnnotationView *)view
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)])
    {
        [delegate mapView:self didDeselectAnnotationView:view];
    }
}

- (void)delegateAnnotationView:(HBIMKAnnotationView *)annotationView
            didChangeDragState:(HBIMKAnnotationViewDragState)newState
                  fromOldState:(HBIMKAnnotationViewDragState)oldState
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)])
    {
        [delegate mapView:self annotationView:annotationView didChangeDragState:newState fromOldState:oldState];
    }
}

- (void)delegateWillStartLoadingMap
{
    if (delegate && [delegate respondsToSelector:@selector(mapViewWillStartLoadingMap:)])
    {
        [delegate mapViewWillStartLoadingMap:self];
    }
}

- (void)delegateDidFinishLoadingMap;
{
    if (delegate && [delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)])
    {
        [delegate mapViewDidFinishLoadingMap:self];
    }
}

- (void)delegateDidFailLoadingMapWithError:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)])
    {
        [delegate mapViewDidFailLoadingMap:self withError:error];
    }
}

// MacMapKit additions
- (void)delegateUserDidClickAndHoldAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    if (delegate && [delegate respondsToSelector:@selector(mapView:userDidClickAndHoldAtCoordinate:)])
    {
        [delegate mapView:self userDidClickAndHoldAtCoordinate:coordinate];
    }

}

- (NSArray *)delegateContextMenuItemsForAnnotationView:(HBIMKAnnotationView *)view
{
    NSArray *items = [NSArray array];
    if (delegate && [delegate respondsToSelector:@selector(mapView:contextMenuItemsForAnnotationView:)])
    {
	items = [delegate mapView:self contextMenuItemsForAnnotationView:view];
    }
    return items;
}


@end
