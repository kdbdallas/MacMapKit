//
//  MKUserLocation+Private.m
//  MapKit
//
//  Created by Rick Fillion on 7/11/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKUserLocation+Private.h"


@implementation HBIMKUserLocation (Private)

- (void)_setLocation:(CLLocation *)aLocation
{
    [self willChangeValueForKey:@"location"];
    location = aLocation;
    [self didChangeValueForKey:@"location"];
}

- (void)_setUpdating:(BOOL)value
{
    [self willChangeValueForKey:@"isUpdating"];
    updating = value;
    [self didChangeValueForKey:@"isUpdating"];
}

@end
