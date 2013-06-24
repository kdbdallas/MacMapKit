//
//  MKMapView+Private.m
//  MapKit
//
//  Created by Rick Fillion on 11-06-28.
//  Copyright 2011 Centrix.ca. All rights reserved.
//

#import "HBIMKMapView+Private.h"
#import "HBIMKWebView.h"
#import "HBIMKUserLocation.h"

@implementation HBIMKMapView (Private)

- (void)customInit
{
    // Initialization code here.    
    if (!webView)
    {
        webView = [[HBIMKWebView alloc] initWithFrame:[self bounds]];
    }
    
    [webView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [webView setFrameLoadDelegate:self];
    [webView setUIDelegate:self];
    [webView setMaintainsBackForwardList:NO];
	// Let's set a custom user agent, as it looks like they're doing some type of UA checking on their end and that's breaking annotations on our end.
	///[webView setCustomUserAgent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.25 (KHTML, like Gecko) Version/6.0 Safari/536.25"];
	NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	if (applicationName == nil)
		applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
	
	[webView setCustomUserAgent:[NSString stringWithFormat:@"%@ AppleWebKit", applicationName]];
	
    // Create the overlay data structures
    overlays = [[NSMutableArray array] retain];
    overlayViews = [[NSMapTable strongToStrongObjectsMapTable] retain];
    overlayScriptObjects = [[NSMapTable strongToStrongObjectsMapTable] retain];
    
    // Create the annotation data structures
    annotations = [[NSMutableArray array] retain];
    selectedAnnotations = [[NSMutableArray array] retain];
    annotationViews = [[NSMapTable strongToStrongObjectsMapTable] retain];
    annotationScriptObjects = [[NSMapTable strongToStrongObjectsMapTable] retain];
    
    [self loadMapKitHtml];
    
    // Create a user location
    userLocation = [[HBIMKUserLocation alloc] init];
}

- (void)loadMapKitHtml
{
    // TODO : make this suck less.
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[HBIMKMapView class]];
    NSString *indexPath = [frameworkBundle pathForResource:@"HBIMapKit" ofType:@"html"];
    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:indexPath]]]; 
    [[[webView mainFrame] frameView] setAllowsScrolling:NO];
    [self addSubview:webView];
}

@end
