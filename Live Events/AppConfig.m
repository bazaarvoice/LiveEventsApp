//
//  AppConfig.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "AppConfig.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppConfig

// Your Bazaarvoice API key -- see https://developer.bazaarvoice.com/ to request a key
+(NSString *)apiKey {
    // Stg
    return @"ml23eof6sxmbunjnz6iwp05xk";
    
    // Prod
    //return @"3pup8wj4h78ywndrgz0d5imna";
}

// The endpoint to use for api requests.  In most cases, this can be api.bazaarvoice.com or stg.api.bazaarvoice.com for staging requests.
+(NSString *)apiEndpoint {
    //return @"api.bazaarvoice.com";
    return @"stg.api.bazaarvoice.com";
}

// A campaignid (and context data value) that will be used to identify submissions from this campaign
+(NSString *)appCampaignID {
    return @"AAO2013";
}

// The name that will be dispayed in all copy "ex. See all <title> products..."
+(NSString *)brandName {
    return @"Acuvue";
}

// Initial list of product ids to display in carousel, comma separated.  Leave blank for no filter.
+(NSString *)initialProducts {
    return @"";
}

// Initial list of category ids to filter in carousel, comma separated.  Leave blank for no filter.
+(NSString *)initialCategory {
    return @"";
}

// Initial list of product ids to display on the "all products" screen, comma separated.  Leave blank for no filter.
+(NSString *)secondaryProducts {
    return @"";
}

// Initial list of category ids to filter on the "all products" screen, comma separated.  Leave blank for no filter.
+(NSString *)secondaryCategory {
    return @"";
}

// The primary tint color of the application -- title bar, progress bar etc.
+(UIColor *)primaryColor {
    // Blue
    return UIColorFromRGB(0x324F85);
}

// The color of secondary actions such as cancel buttons
+(UIColor *)secondaryActionColor {
    // Light gray
    return UIColorFromRGB(0xDADADA);
}

// The color of error dialogs and buttons -- should be distinct from primaryColor
+(UIColor *)errorColor {
    // Bright red
    return UIColorFromRGB(0xFF0000);
}

// The name of the background image to use throughout the application.
+(NSString *)backgroundImage {
    return @"logo.png";
}

// Indicates whether users should have the option of emailing themselves a product to review later.  If not enabled, the email icon will be hidden.
+(BOOL)emailEnabled {
    return YES;
}

// Custom default text for emails sent from this application
+(NSString *)emailText {
    return @"Thanks for your interest in providing a review.  Click the link above to view the review submission form.";
}

// Indicates whether searches on the "all products" screen will act as a filter of secondaryProducts, or will go to the network and search all products
+(BOOL)performNetworkSearchForAllProducts {
    return YES;
}

@end
