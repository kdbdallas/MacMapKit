/*
 *  MKGeometry.h
 *  MapKit
 *
 *  Created by Rick Fillion on 7/11/10.
 *  Copyright 2010 Centrix.ca. All rights reserved.
 *
 */

#import <CoreLocation/CoreLocation.h>

typedef struct {
    CLLocationDegrees latitudeDelta;
    CLLocationDegrees longitudeDelta;
} HBIMKCoordinateSpan;

typedef struct {
    CLLocationCoordinate2D center;
    HBIMKCoordinateSpan span;
} HBIMKCoordinateRegion;


static inline HBIMKCoordinateSpan HBIMKCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
{
    HBIMKCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

static inline HBIMKCoordinateRegion HBIMKCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, HBIMKCoordinateSpan span)
{
    HBIMKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;
    return region;
}

// An HBIMKMapPoint is a coordinate that has been projected for use on the
// two-dimensional map.  An HBIMKMapPoint always refers to a place in the world
// and can be converted to a CLLocationCoordinate2D and back.
typedef struct {
    double x;
    double y;
} HBIMKMapPoint;

typedef struct {
    double width;
    double height;
} HBIMKMapSize;

typedef struct {
    HBIMKMapPoint origin;
    HBIMKMapSize size;
} HBIMKMapRect;

/*
// HBIMKZoomScale provides a conversion factor between HBIMKMapPoints and screen points.
// When HBIMKZoomScale = 1, 1 screen point = 1 HBIMKMapPoint.  When HBIMKZoomScale is
// 0.5, 1 screen point = 2 HBIMKMapPoints.
typedef CGFloat HBIMKZoomScale;

// The map point for the coordinate (-90,180)
extern const HBIMKMapSize HBIMKMapSizeWorld;
// The rect that contains every map point in the world.
extern  const HBIMKMapRect HBIMKMapRectWorld;

 
// Conversion between unprojected and projected coordinates
extern  HBIMKMapPoint HBIMKMapPointForCoordinate(CLLocationCoordinate2D coordinate);
extern  CLLocationCoordinate2D HBIMKCoordinateForMapPoint(HBIMKMapPoint mapPoint);

// Conversion between distances and projected coordinates
extern  CLLocationDistance HBIMKMetersPerMapPointAtLatitude(CLLocationDegrees latitude);
extern  double HBIMKMapPointsPerMeterAtLatitude(CLLocationDegrees latitude);

extern  CLLocationDistance HBIMKMetersBetweenMapPoints(HBIMKMapPoint a, HBIMKMapPoint b);

extern  const HBIMKMapRect HBIMKMapRectNull;*/

// Geometric operations on HBIMKMapPoint/Size/Rect.  See CGGeometry.h for 
// information on the CGFloat versions of these functions.
static inline HBIMKMapPoint HBIMKMapPointMake(double x, double y) {
    return (HBIMKMapPoint){x, y};
}
static inline HBIMKMapSize HBIMKMapSizeMake(double width, double height) {
    return (HBIMKMapSize){width, height};
}

static inline HBIMKMapRect HBIMKMapRectMake(double x, double y, double width, double height) {
    return (HBIMKMapRect){ HBIMKMapPointMake(x, y), HBIMKMapSizeMake(width, height) };
}
static inline double HBIMKMapRectGetMinX(HBIMKMapRect rect) {
    return rect.origin.x;
}
static inline double HBIMKMapRectGetMinY(HBIMKMapRect rect) {
    return rect.origin.y;
}
static inline double HBIMKMapRectGetMidX(HBIMKMapRect rect) {
    return rect.origin.x + rect.size.width / 2.0;
}
static inline double HBIMKMapRectGetMidY(HBIMKMapRect rect) {
    return rect.origin.y + rect.size.height / 2.0;
}
static inline double HBIMKMapRectGetMaxX(HBIMKMapRect rect) {
    return rect.origin.x + rect.size.width;
}
static inline double HBIMKMapRectGetMaxY(HBIMKMapRect rect) {
    return rect.origin.y + rect.size.height;
}
static inline double HBIMKMapRectGetWidth(HBIMKMapRect rect) {
    return rect.size.width;
}
static inline double HBIMKMapRectGetHeight(HBIMKMapRect rect) {
    return rect.size.height;
}
static inline BOOL HBIMKMapPointEqualToPoint(HBIMKMapPoint point1, HBIMKMapPoint point2) {
    return point1.x == point2.x && point1.y == point2.y;
}
static inline BOOL HBIMKMapSizeEqualToSize(HBIMKMapSize size1, HBIMKMapSize size2) {
    return size1.width == size2.width && size1.height == size2.height;
}
static inline BOOL HBIMKMapRectEqualToRect(HBIMKMapRect rect1, HBIMKMapRect rect2) {
    return
    HBIMKMapPointEqualToPoint(rect1.origin, rect2.origin) &&
    HBIMKMapSizeEqualToSize(rect1.size, rect2.size);
}

static inline BOOL HBIMKMapRectIsNull(HBIMKMapRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y);
}
static inline BOOL HBIMKMapRectIsEmpty(HBIMKMapRect rect) {
    return HBIMKMapRectIsNull(rect) || (rect.size.width == 0.0 && rect.size.height == 0.0);
}

static inline NSString *HBIMKStringFromMapPoint(HBIMKMapPoint point) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", point.x, point.y];
}

static inline NSString *HBIMKStringFromMapSize(HBIMKMapSize size) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", size.width, size.height];
}

static inline NSString *HBIMKStringFromMapRect(HBIMKMapRect rect) {
    return [NSString stringWithFormat:@"{%@, %@}", HBIMKStringFromMapPoint(rect.origin), HBIMKStringFromMapSize(rect.size)];
}
/*
extern HBIMKMapRect HBIMKMapRectUnion(HBIMKMapRect rect1, HBIMKMapRect rect2);
extern MKMapRect MKMapRectIntersection(MKMapRect rect1, MKMapRect rect2);
extern MKMapRect MKMapRectInset(MKMapRect rect, double dx, double dy);
extern MKMapRect MKMapRectOffset(MKMapRect rect, double dx, double dy);
extern void MKMapRectDivide(MKMapRect rect, MKMapRect *slice, MKMapRect *remainder, double amount, CGRectEdge edge);

extern BOOL MKMapRectContainsPoint(MKMapRect rect, MKMapPoint point);
extern BOOL MKMapRectContainsRect(MKMapRect rect1, MKMapRect rect2);
extern BOOL MKMapRectIntersectsRect(MKMapRect rect1, MKMapRect rect2);

extern MKCoordinateRegion MKCoordinateRegionForMapRect(MKMapRect rect);

extern BOOL MKMapRectSpans180thMeridian(MKMapRect rect);
// For map rects that span the 180th meridian, this returns the portion of the rect
// that lies outside of the world rect wrapped around to the other side of the
// world.  The portion of the rect that lies inside the world rect can be 
// determined with MKMapRectIntersection(rect, MKMapRectWorld).
extern MKMapRect MKMapRectRemainder(MKMapRect rect);
 */
