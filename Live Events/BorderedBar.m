//
//  BorderedBar.m
//  Live Events
//
//  Created by Bazaarvoice Engineering on 6/19/13.
//  Copyright (c) 2013 Bazaarvoice. All rights reserved.
//

#import "BorderedBar.h"

@implementation BorderedBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, 0,0); //start at this point
    CGContextAddLineToPoint(context, rect.size.width, 0); //draw to this point
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 0,rect.size.height); //start at this point
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
