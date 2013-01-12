//
//  SquareView.m
//  Square
//
//  Created by Trung Phan on 1/11/13.
//  Copyright (c) 2013 Trung Phan. All rights reserved.
//

#import "SquareView.h"

@interface SquareView()

@end

@implementation SquareView

#define DEFAULT_SCALE 0.9

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@synthesize scale = _scale;

- (CGFloat)scale {
    if (_scale == 0) {
        _scale = DEFAULT_SCALE;
    }
    return _scale;
}

- (void)setScale:(CGFloat)scale {
    if (scale > 0 && _scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

@synthesize rotation = _rotation;

- (void)setRotation:(CGFloat)rotation {
    if (_rotation != rotation) {
        _rotation = rotation;
        [self setNeedsDisplay];
    }
}

@synthesize color = _color;

- (UIColor *)color {
    if (_color == nil) {
        _color = [UIColor blueColor];
    }
    return _color;
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        [self setNeedsDisplay];
    }
}

- (IBAction)handleRotationGesture:(UIRotationGestureRecognizer *)sender {
    self.rotation = sender.rotation;
}

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    self.scale *= sender.scale;
    sender.scale = 1;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(context);

    
    CGRect boundingBox = CGContextGetClipBoundingBox(context);
    CGFloat size = self.scale * MIN(boundingBox.size.width, boundingBox.size.height);
    
    CGContextSaveGState(context);

    CGPoint center = CGPointMake(boundingBox.origin.x + boundingBox.size.width / 2, boundingBox.origin.y + boundingBox.size.height / 2);
    
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextRotateCTM(context, self.rotation);
    
    for (int i = 11; i >= 0; i--) {
        CGFloat r, g, b, a;
        CGFloat colorScale = (i+1.0)/12.0;
        [self.color getRed:&r green:&g blue:&b alpha:&a];
        
        UIColor *newColor = [UIColor colorWithRed:(r + (1-r)*colorScale) green:(g + (1-g)*colorScale) blue:(b + (1-b)*colorScale) alpha:a];
        
        [newColor setFill];
        CGFloat rectSize = (size * (i * 2 + 1)) / (24.0 - 1);
        CGRect rectToDraw = CGRectMake(-rectSize/2, -rectSize/2, rectSize, rectSize);
        CGContextFillRect(context, rectToDraw);
    }
    
    CGContextRestoreGState(context);
    
}


@end
