//
//  AppConfig.h
//  Live Events
//
//  Created by Alex Medearis on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+(UIColor *)primaryColor;
+(UIColor *)errorColor;
+(UIColor *)disabledColor;

+(NSString *)apiKey;
+(NSString *)apiEndpoint;
+(NSString *)title;

@end
