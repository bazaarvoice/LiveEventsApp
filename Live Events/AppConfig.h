//
//  AppConfig.h
//  Live Events
//
//  AppConfig provides a single point of entry for app customization.  See
//  AppConfig.m for current values;
//
//  Created by Bazaarvoice Engineering on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

// The primary tint color of the application -- title bar, progress bar etc.
+(UIColor *)primaryColor;
// The color of secondary actions such as cancel buttons
+(UIColor *)secondaryActionColor;
// The color of error dialogs and buttons -- should be distinct from primaryColor
+(UIColor *)errorColor;


// Your Bazaarvoice API key -- see https://developer.bazaarvoice.com/ to request a key
+(NSString *)apiKey;
// The endpoint to use for api requests.  In most cases, this can be api.bazaarvoice.com.
+(NSString *)apiEndpoint;

// The name that will be dispayed in all copy "ex. See all <title> products..."
+(NSString *)title;
// The name of the background image to use throughout the application.
+(NSString *)backgroundImage;
// A context data value (and campaignid) that will be used to identify submissions from this campaign
+(NSString *)appCDV;

// Custom default text for emails sent from this application
+(NSString *)emailText;

@end
