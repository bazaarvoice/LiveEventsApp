//
//  BackgroundView.m
//  Live Events
//
//  Created by Alex Medearis on 6/19/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "BackgroundView.h"
#import "RoundedCornerButton.h"

@interface BackgroundView()

@property (strong) UIImage * background;
@property (strong) UIImage * logo;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;

@end

@implementation BackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    // Initialization code
    self.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"A_Pattern.png"]];
    self.logo = [self convertImageToGrayScale:[UIImage imageNamed:@"dove.jpg"]];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    float imageWHRatio = self.logo.size.width / self.logo.size.height;
    float rectWHRatio = rect.size.width / rect.size.height;
    
    CGRect drawRect;
    if(imageWHRatio > rectWHRatio) {
        float scale = rect.size.width / self.logo.size.width ;
        float rectHeight = self.logo.size.height * scale;
        float offset = (rect.size.height - rectHeight) / 2;
        drawRect = CGRectMake(0, offset, rect.size.width, rectHeight);
    } else {
        float scale = rect.size.height / self.logo.size.height;
        float rectWidth = self.logo.size.width * scale;
        float offset = (rect.size.width - rectWidth) / 2;
        drawRect = CGRectMake(offset, 0, rectWidth, rect.size.height);
    }
    [self.logo drawInRect:drawRect blendMode:kCGBlendModeMultiply alpha:.7];
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

@end
