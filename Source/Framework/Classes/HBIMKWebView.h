//
//  MKWebView.h
//  MapKit
//
//  Created by Rick Fillion on 10-12-12.
//  Copyright 2010 Centrix.ca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface HBIMKWebView : WebView
{
    NSDate *__weak lastHitTestDate;
}

@property (weak, nonatomic, readonly) NSDate *lastHitTestDate;

@end
