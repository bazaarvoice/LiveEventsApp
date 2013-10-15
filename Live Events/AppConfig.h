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

// Your Bazaarvoice API key -- see https://developer.bazaarvoice.com/ to request a key
+(NSString *)apiKey;
// The endpoint to use for api requests.  In most cases, this can be api.bazaarvoice.com or stg.api.bazaarvoice.com for staging requests.
+(NSString *)apiEndpoint;
// A campaignid (and context data value) that will be used to identify submissions from this campaign
+(NSString *)appCampaignID;
// The name that will be dispayed in all copy "ex. See all <title> products..."
+(NSString *)brandName;

// Initial list of product ids to display in carousel, comma separated.  Leave blank for no filter.
+(NSString *)initialProducts;
// Initial list of category ids to filter in carousel, comma separated.  Leave blank for no filter.
+(NSString *)initialCategory;
// Initial list of product ids to display on the "all products" screen, comma separated.  Leave blank for no filter.
+(NSString *)secondaryProducts;
// Initial list of category ids to filter on the "all products" screen, comma separated.  Leave blank for no filter.
+(NSString *)secondaryCategory;

// The primary tint color of the application -- title bar, progress bar etc.
+(UIColor *)primaryColor;
// The color of secondary actions such as cancel buttons
+(UIColor *)secondaryActionColor;
// The color of error dialogs and buttons -- should be distinct from primaryColor
+(UIColor *)errorColor;

// The name of the background image to use throughout the application.
+(NSString *)backgroundImage;

// Indicates whether users should have the option of emailing themselves a product to review later.  If not enabled, the email icon will be hidden.
+(BOOL)emailEnabled;

// Custom default text for emails sent from this application
+(NSString *)emailText;

// Indicates whether searches on the "all products" screen will act as a filter of secondaryProducts, or will go to the network and search all products
+(BOOL)performNetworkSearchForAllProducts;


@end
