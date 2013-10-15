//
//  FadeLabel.h
//  Live Events
//
//  UILabel capable of fading between it's initial color and a secondary color.
//
//  Created by Bazaarvoice Engineering on 6/19/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeLabel : UILabel

@property (assign) UIColor * secondaryColor;

- (void)showSecondaryColor:(BOOL)secondaryColorVisible;

@end
