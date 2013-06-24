//
//  MKPolyline.m
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKPolyline.h"

@interface HBIMKPolyline (Private)

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end


@implementation HBIMKPolyline

+ (HBIMKPolyline *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    return [[[HBIMKPolyline alloc] initWithCoordinates:coords count:count] autorelease];
}

- (CLLocationCoordinate2D) coordinate
{
    return [super coordinate];
}

- (void)dealloc
{
    free(coordinates);
    [super dealloc];
}

#pragma mark Private

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count
{
    if (self = [super init])
    {
        coordinates = malloc(sizeof(CLLocationCoordinate2D) * count);
        for (int i = 0; i < count; i++)
        {
            coordinates[i] = coords[i];
        }
        coordinateCount = count;
    }
    return self;
}

@end
