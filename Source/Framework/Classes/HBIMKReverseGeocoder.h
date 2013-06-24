//
//  MKReverseGeocoder.h
//  MapKit
//
//  Created by Rick Fillion on 7/24/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CLLocation.h>
#import <WebKit/WebKit.h>
#import <HBIMapKit/HBIMKTypes.h>

@class HBIMKPlacemark;
@protocol HBIMKReverseGeocoderDelegate;

@interface HBIMKReverseGeocoder : NSObject {
    id <HBIMKReverseGeocoderDelegate> delegate;
    CLLocationCoordinate2D coordinate;
    HBIMKPlacemark *placemark;
    BOOL querying;
@private
    WebView *webView;
    BOOL webViewLoaded;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;


// A MKReverseGeocoder object should only be started once.
- (void)start;
- (void)cancel;

@property (nonatomic, assign) id<HBIMKReverseGeocoderDelegate> delegate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;      // the exact coordinate being reverse geocoded.
@property (nonatomic, readonly) HBIMKPlacemark *placemark;
@property (nonatomic, readonly, getter=isQuerying) BOOL querying;

@end

@protocol HBIMKReverseGeocoderDelegate <NSObject>
@required
- (void)reverseGeocoder:(HBIMKReverseGeocoder *)geocoder didFindPlacemark:(HBIMKPlacemark *)placemark;
// There are at least two types of errors:
//   - Errors sent up from the underlying connection (temporary condition)
//   - Result not found errors (permanent condition).  The result not found errors
//     will have the domain MKErrorDomain and the code MKErrorPlacemarkNotFound
- (void)reverseGeocoder:(HBIMKReverseGeocoder *)geocoder didFailWithError:(NSError *)error;
@end
