//
//  MKPlacemark.h
//  MapKit
//
//  Created by Rick Fillion on 7/24/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HBIMapKit/HBIMKAnnotation.h>
#import <CoreLocation/CLLocation.h>

@interface HBIMKPlacemark : NSObject <HBIMKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

// An address dictionary is a dictionary in the same form as returned by 
// ABRecordCopyValue(person, kABPersonAddressProperty).
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
       addressDictionary:(NSDictionary *)addressDictionary;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Can be turned into a formatted address with ABCreateStringWithAddressDictionary.
@property (weak, nonatomic, readonly) NSDictionary *addressDictionary;

@property (weak, nonatomic, readonly) NSString *thoroughfare; // street address, eg 1 Infinite Loop
@property (weak, nonatomic, readonly) NSString *subThoroughfare;
@property (weak, nonatomic, readonly) NSString *locality; // city, eg. Cupertino
@property (weak, nonatomic, readonly) NSString *subLocality; // neighborhood, landmark, common name, etc
@property (weak, nonatomic, readonly) NSString *administrativeArea; // state, eg. CA
@property (weak, nonatomic, readonly) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (weak, nonatomic, readonly) NSString *postalCode; // zip code, eg 95014
@property (weak, nonatomic, readonly) NSString *country; // eg. United States
@property (weak, nonatomic, readonly) NSString *countryCode; // eg. US

-(id)initWithGoogleGeocoderResult:(NSDictionary *)result;

@end
