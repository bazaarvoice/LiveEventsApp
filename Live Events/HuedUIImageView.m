   //
//  HuedUIImageView.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 9/10/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "HuedUIImageView.h"
#import "AppConfig.h"

@implementation HuedUIImageView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.image = self.image;
}


-(void)setImage:(UIImage *)image {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    // Attempt to blend the image with a hue color
    BOOL success = [[AppConfig primaryColor] getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if(success){
        [super setImage:[self imageWithImage:image hue:hue saturation:saturation brightness:brightness alpha:alpha]];
    } else {
        [super setImage:image];
    }
}


- (UIImage*) imageWithImage:(UIImage*) source hue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha

// Note: the hue input ranges from 0.0 to 1.0, both red.  Values outside this range will be clamped to 0.0 or 1.0.
{
    // Find the image dimensions.
    CGSize imageSize = [source size];
    CGRect imageExtent = CGRectMake(0,0,imageSize.width,imageSize.height);
    
    // Create a context containing the image.
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw black background to preserve color of transparent pixels
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, imageExtent);
    
    // draw original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextTranslateCTM(context, 0, imageExtent.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, imageExtent, source.CGImage);
    
    // tint image (loosing alpha) - the luminosity of the original image is preserved
    CGContextSetBlendMode(context, kCGBlendModeColor);
    [[AppConfig primaryColor] setFill];
    CGContextFillRect(context, imageExtent);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, imageExtent, source.CGImage);
    
    // Retrieve the new image.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
