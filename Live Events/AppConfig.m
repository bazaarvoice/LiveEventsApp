//
//  AppConfig.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

// The primary tint color of the application -- title bar, progress bar etc.
+(UIColor *)primaryColor {
    // Blue
    return [UIColor colorWithRed:50/255.0 green:79/255.0 blue:133/255.0 alpha:1.0];
}

// The color of secondary actions such as cancel buttons
+(UIColor *)secondaryActionColor {
    // Light gray
    return [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
}

// The color of error dialogs and buttons -- should be distinct from primaryColor
+(UIColor *)errorColor {
    // Bright red
    return [UIColor colorWithRed:225/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}

// Your Bazaarvoice API key -- see https://developer.bazaarvoice.com/ to request a key
+(NSString *)apiKey {
    return @"ey25dkemibncqvekcw3c8yonm";
}

// The endpoint to use for api requests.  In most cases, this can be api.bazaarvoice.com.
+(NSString *)apiEndpoint {
    return @"reviews.walmart.com";
}

// The name that will be dispayed in all copy "ex. See all <title> products..."
+(NSString *)title {
    return @"Walmart";
}
// The name of the background image to use throughout the application.
+(NSString *)backgroundImage {
    return @"walmart.jpg";
}

// A context data value (and campaignid) that will be used to identify submissions from this campaign
+(NSString *)appCDV {
    return @"someCDV";
}

+(NSString *)emailText {
    return @"Thanks for your interest in providing a review.  Click the link above to view the review submission form.";
}


@end
