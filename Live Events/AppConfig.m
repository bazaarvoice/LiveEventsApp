//
//  AppConfig.m
//  Live Events
//
//  Created by Alex Medearis on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig


+(UIColor *)BVBrightBlue {
    return [UIColor colorWithRed:34/255.0 green:114/255.0 blue:185/255.0 alpha:1.0];
}

+(UIColor *)BVBrightRed {
    return [UIColor colorWithRed:225/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
}

+(UIColor *)BVVeryLightGray {
    return [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
}


+(UIColor *)BVDarkBlue {
    return [UIColor colorWithRed:50/255.0 green:79/255.0 blue:133/255.0 alpha:1.0];
}


+(UIColor *)primaryColor {
    return [AppConfig BVDarkBlue];
}

+(UIColor *)errorColor {
    return [AppConfig BVBrightRed];
}

+(UIColor *)disabledColor {
    return [AppConfig BVVeryLightGray];
}


+(NSString *)apiKey {
    return @"reviews.walmart.com";
}

+(NSString *)apiEndpoint {
    return @"ey25dkemibncqvekcw3c8yonm";
}

+(NSString *)title {
    return @"Nissan";
}

+(NSString *)backgroundImage {
    return @"walmart.jpg";
}

@end
