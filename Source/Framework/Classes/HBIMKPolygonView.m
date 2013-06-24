//
//  MKPolygonView.m
//  MapKit
//
//  Created by Rick Fillion on 7/15/10.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import "HBIMKPolygonView.h"
#import <CoreLocation/CoreLocation.h>

@interface HBIMKPolygonView (Private)

- (NSArray *)pathForPolygon:(HBIMKPolygon *)aPolygon webScriptObject:(WebScriptObject *)webScriptObject;

@end


@implementation HBIMKPolygonView


- (id)initWithPolygon:(HBIMKPolygon *)polygon;
{
    if (self = [super initWithOverlay:polygon])
    {
    }
    return self;
}

- (void)dealloc
{
    [path release];
    [super dealloc];
}

- (HBIMKPolygon *)polygon
{
    return [super overlay];
}

- (NSString *)viewPrototypeName
{
    return @"google.maps.Polygon";
}

- (NSDictionary *)options
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:[super options]];
    
    if (path)
    {
        if (!interiorPaths)
        {
            [options setObject:path forKey:@"path"];
        }
        else {
            NSMutableArray *allPaths = [NSMutableArray arrayWithObject:path];
            [allPaths addObjectsFromArray:interiorPaths];
            [options setObject:allPaths forKey:@"paths"];
        }

    }
    
    return [[options copy] autorelease];
}

- (void)draw:(WebScriptObject *)overlayScriptObject
{
    if (!path)
    {
        path = [self pathForPolygon:[self polygon] webScriptObject:overlayScriptObject];
        [path retain];
        if ([self polygon].interiorPolygons)
        {
            NSMutableArray *interiorPolygonPaths = [NSMutableArray array];
            for (HBIMKPolygon *aPolygon in [self polygon].interiorPolygons)
            {
                NSArray *interiorPath = [self pathForPolygon:aPolygon webScriptObject:overlayScriptObject];
                [interiorPolygonPaths addObject:interiorPath];
            }
            interiorPaths = [[[interiorPolygonPaths copy] autorelease] retain];
        }
    }
    
    [super draw:overlayScriptObject];
}

#pragma mark Private

- (NSArray *)pathForPolygon:(HBIMKPolygon *)aPolygon webScriptObject:(WebScriptObject *)webScriptObject
{
    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * aPolygon.coordinateCount);
    NSRange range = NSMakeRange(0, aPolygon.coordinateCount);
    [aPolygon getCoordinates:coordinates range:range];
    NSMutableArray *newPath = [NSMutableArray array];
    
    for (int i = 0; i< aPolygon.coordinateCount; i++)
    {
        CLLocationCoordinate2D coordinate = coordinates[i];
        NSString *script = [NSString stringWithFormat:@"new google.maps.LatLng(%f, %f);", coordinate.latitude, coordinate.longitude];
        WebScriptObject *latlng = (WebScriptObject *)[webScriptObject evaluateWebScript:script];
        [newPath addObject:latlng];
    }
    return  [[newPath copy] autorelease];
}

@end
