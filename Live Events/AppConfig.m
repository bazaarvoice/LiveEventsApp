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
    return @"ey25dkemibncqvekcw3c8yonm";
}

// The endpoint to use for api requests.  In most cases, this can be api.bazaarvoice.com or stg.api.bazaarvoice.com for staging requests.
+(NSString *)apiEndpoint {
    return @"stg.api.bazaarvoice.com";
}

// A context data value (and campaignid) that will be used to identify submissions from this campaign
+(NSString *)appCDV {
    return @"liveEventCDV";
}

// The name that will be dispayed in all copy "ex. See all <title> products..."
+(NSString *)brandName {
    return @"LiveEvent Co.";
}

// Initial list of product ids to display in carousel, comma separated 
+(NSString *)initialProducts {
    return @"27101950,27101948,27101946,27101945,27101944,24761799,26354605,24857366,26678596,26906088,24537160,21151436,26975622,26975621,26975620,26975619,26975618,26975616,25634479,26464937,24633531,24244654,23001149,25246401,25246400,16671381,25139301,27101953,26922972,24857342,24857338,24857337,24761803,22959246,22959245,22726173,22726171,21129050,25710579,24501961,23764195,22018267,22018255,27130731,24857302,24857361,24857359,25863298,24430386,24787041,24787040,26680901,26680887,26012799,25863345,25863344,25863343,25634553,25246421,25246420,23268060,20968683,25440895,23991159,24625660,24625659,24511209,24511205,24413342,23583146,23583145,26827376,24062803,24062802,24062801,24221406,26095121,26095120,24017198,24017186,21106759,24857365,24625654,26906090,22881103,21095595,26906086,26095141,24413343,24414348,21151441,21151440,21151439,21151438,21151437,21151435,21151434,26095143,26095134,26354616,25634436,25634438,25634445";
}

// Initial list of product ids to display on the "all products" screen, comma separated
+(NSString *)secondaryProducts {
    return @"27101950,27101948,27101946,27101945,27101944,24761799,26354605,24857366,26678596,26906088,24537160,21151436,26975622,26975621,26975620,26975619,26975618,26975616,25634479,26464937,24633531,24244654,23001149,25246401,25246400,16671381,25139301,27101953,26922972,24857342,24857338,24857337,24761803,22959246,22959245,22726173,22726171,21129050,25710579,24501961,23764195,22018267,22018255,27130731,24857302,24857361,24857359,25863298,24430386,24787041,24787040,26680901,26680887,26012799,25863345,25863344,25863343,25634553,25246421,25246420,23268060,20968683,25440895,23991159,24625660,24625659,24511209,24511205,24413342,23583146,23583145,26827376,24062803,24062802,24062801,24221406,26095121,26095120,24017198,24017186,21106759,24857365,24625654,26906090,22881103,21095595,26906086,26095141,24413343,24414348,21151441,21151440,21151439,21151438,21151437,21151435,21151434,26095143,26095134,26354616,25634436,25634438,25634445";
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
