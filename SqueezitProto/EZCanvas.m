//
//  EZCanvas.m
//  SqueezitProto
//
//  Created by Apple on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZCanvas.h"
#import "Constants.h"

@interface EZCanvas()
{
    
}

//Will create a Bitmap context for me to use
- (CGContextRef) createBitmapContext:(CGSize)area;

@end


//The info is what you passing though.
void MyPatternDraw(void *info, CGContextRef ctx){
    EZDEBUG(@"MyPatternDraw get called");
    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, 4, 4));
    CGContextSetRGBFillColor(ctx, 0, 1, 0, 1);
    CGContextFillRect(ctx, CGRectMake(5, 0, 4, 4));
    
    CGContextSetRGBFillColor(ctx, 0, 0.5, 0.5, 1);
    CGContextFillRect(ctx, CGRectMake(0, 5, 4, 4));
    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0.5, 1);
    CGContextFillRect(ctx, CGRectMake(5, 5, 4, 4));
}

@implementation EZCanvas

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (CGContextRef) createBitmapContext:(CGSize)area
{
    CGContextRef res = NULL;
    CGColorSpaceRef colorSpace;
    void* bitmapData;
    //Total bytes for the allocated bitmap
    int bitmapByteCount;
    
    //How many bytes per row?
    int bitmapBytesPerRow;
    
    bitmapBytesPerRow = area.width * 4;
    
    bitmapByteCount = bitmapBytesPerRow * area.height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    bitmapData = calloc(1, bitmapByteCount);
    
    res = CGBitmapContextCreate(bitmapData, area.width, area.height, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    if(res == NULL){
        free(bitmapData);
        EZDEBUG(@"failed to create bitmap");
        return NULL;
    }
    CGColorSpaceRelease(colorSpace);
    return res;
}



- (void) fillPattern:(CGContextRef)ctx
{
    CGPatternRef pattern;
    //Why do we need color space?
    //Is this like pallate?
    CGColorSpaceRef patternSpace;
    
    CGFloat alpha = 1;
    
    static const CGPatternCallbacks callbacks = {0,
            &MyPatternDraw,
            NULL};
    CGContextSaveGState(ctx);
    patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(ctx, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    pattern = CGPatternCreate(NULL, CGRectMake(0, 0, 10, 10), CGAffineTransformIdentity, 10, 10, kCGPatternTilingConstantSpacing, YES, &callbacks);
    
    CGContextSetFillPattern(ctx, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(ctx, CGRectMake(100, 100, 100, 100));
    CGContextRestoreGState(ctx);
}

- (void) drawLinearGradient:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    //CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 200, 200));
    CGContextAddArc(ctx, 160, 180, 120, 0.0, radians(90), 1);
    //CGContextMoveToPoint(ctx, 280, 180);
    //CGContextAddLineToPoint(ctx, 160, 180);
    //CGContextAddLineToPoint(ctx, 160, 300);
    CGContextMoveToPoint(ctx, 160, 300);
    CGContextAddLineToPoint(ctx, 160, 180);
    CGContextAddLineToPoint(ctx, 280, 180);
    
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    CGFloat locations[3] = {0.0, 0.5, 1.0};
    CGFloat components[12] = {1.0, 0.5, 0.4, 1.0,
        0.8, 0.8, 0.3, 1.0,
        0.5,0.5,0.0,1.0
    };
    colorSpace = CGColorSpaceCreateDeviceRGB();
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    CGPoint startPoint, endPoint;
    startPoint.x = 0.0;
    startPoint.y = 0.0;
    endPoint.x = 320;
    endPoint.y = 367;
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint,0);
    CGContextRestoreGState(ctx);
}

- (void) transparentLayer:(CGContextRef)ctx
{
    //CGContextBeginTransparencyLayer(ctx, nil);
    CGContextSetRGBFillColor(ctx, 0.5, 0.5, 0, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(100, 50, 80, 40));
    CGContextFillEllipseInRect(ctx, CGRectMake(130, 45, 70, 50));
    CGContextFillEllipseInRect(ctx, CGRectMake(150, 60, 50, 50));
    //CGContextEndTransparencyLayer(ctx);
}

- (void) layerPattern:(CGContextRef)ctx
{
    CGLayerRef layer = CGLayerCreateWithContext(ctx, CGSizeMake(100, 44), NULL);
    CGContextRef layerContext = CGLayerGetContext(layer);
    CGContextSetRGBFillColor(layerContext, 0.5, 0, 0.5, 1);
    CGContextFillRect(layerContext, CGRectMake(0, 0, 50, 44));
    CGContextSetRGBFillColor(layerContext, 0.0, 0.5, 0.5, 1);
    CGContextFillRect(layerContext, CGRectMake(50, 0, 50, 44));
    CGContextSaveGState(ctx);
    
    for(int i = 0; i < 5; i++){
        CGContextDrawLayerAtPoint(ctx, CGPointMake(0, 0), layer);
        CGContextTranslateCTM(ctx, 0, 44.0);
    }
    CGContextRestoreGState(ctx);
    
}
//Could I apply shadow to all I have drawn?
//Let's give a try. 
- (void)drawRect:(CGRect)rect
{
    EZDEBUG(@"drawRect get called");
    CGRect myBoundingBox = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextRef bitmapCtx = [self createBitmapContext:myBoundingBox.size];
    CGContextSetRGBFillColor(bitmapCtx, 1, 1, 1, 1);
    CGContextFillRect(bitmapCtx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    [self layerPattern:bitmapCtx];
    [self drawLinearGradient:bitmapCtx];
    //Shadow related code
    CGSize shadowOffset = CGSizeMake(-5, 5);
    CGFloat shadowColorValues[] = {1, 0, 0, 0.6};
    CGColorRef shadowColor;
    CGColorSpaceRef shadowColorSpace;
    CGContextSetShadow(bitmapCtx, shadowOffset, 5);
    
    CGContextSetRGBFillColor(bitmapCtx, 0, 0.8, 0.4, 1);
    CGContextFillEllipseInRect(bitmapCtx, CGRectMake(100, 10, 50, 80));
    //CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
    
    shadowColorSpace = CGColorSpaceCreateDeviceRGB();
    shadowColor = CGColorCreate(shadowColorSpace, shadowColorValues);
    CGContextSetShadowWithColor(bitmapCtx, shadowOffset, 10, shadowColor);
    
    
    CGContextSetRGBFillColor(bitmapCtx, 1, 0, 0, 1);
    CGContextFillRect(bitmapCtx, CGRectMake(0, 0, 50, 50));
    CGContextSetRGBFillColor(bitmapCtx, 0, 1, 0, 1);
    CGContextFillRect(bitmapCtx, CGRectMake(10, myBoundingBox.size.height - 60, 50, 50));
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //CGAffineTransform transform = CGAffineTransformMakeRotation(radians(45.0));
    CGAffineTransform identity = CGAffineTransformIdentity;
    CGAffineTransform move = CGAffineTransformMakeTranslation(-50, -90);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(45);
    CGAffineTransform moveBack = CGAffineTransformMakeTranslation(50,90); 
    CGAffineTransform combined = CGAffineTransformConcat(identity, move);
    combined = CGAffineTransformConcat(combined, rotate);
    combined = CGAffineTransformConcat(rotate, moveBack);
    
    CGPathAddRect(path, &combined, CGRectMake(20, 60, 60, 60));
    CGPathAddRect(path, &combined, CGRectMake(30,70, 40, 40));
    CGPathCloseSubpath(path);
    
    CGContextAddPath(bitmapCtx, path);
    //Should we call this too?
    //Let's try
    //CGContextClosePath(bitmapCtx);
    //Fill by using nonzero winding number rule
    CGContextSetRGBFillColor(bitmapCtx, 0.6, 0.6, 0.6, 1);
    //CGContextFillPath(bitmapCtx);
    CGContextEOFillPath(bitmapCtx);
    
    CGPathRelease(path);
    
    //Show the effect of tansparent layer
    //I should be useful more than just the layer
    [self transparentLayer:bitmapCtx];
    
    
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, 0, 10, 200);
    
    CGPoint points[4] = {CGPointMake(110, 200), CGPointMake(110, 300), CGPointMake(10, 300), CGPointMake(10, 200)};
    
    CGPathAddLines(path, nil, points, 4);
    //CGPathCloseSubpath(path);
    
    
    CGPathMoveToPoint(path, nil, 20, 210);
    CGPoint smallPoints[4] = {CGPointMake(20, 290), CGPointMake(100, 290), CGPointMake(100, 210), CGPointMake(20, 210) };
    
    CGPathAddLines(path, nil, smallPoints, 4);
    CGPathCloseSubpath(path);
    CGContextAddPath(bitmapCtx, path);
    CGContextSetRGBFillColor(bitmapCtx, 0.5, 0.3, 0.3, 1);
    CGContextFillPath(bitmapCtx);
    CGPathRelease(path);
    
    [self fillPattern:bitmapCtx];
    
    
    CGImageRef image = CGBitmapContextCreateImage(bitmapCtx);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //When it will take effect, Let's check the effect
    //So it just doesn't matter when you do it.
    //CGContextRotateCTM(ctx, radians(-10.0));
    //CGContextScaleCTM(ctx, 0.5, 0.75);
    CGContextDrawImage(ctx, myBoundingBox, image);
    //[self drawLinearGradient:ctx];
    char* bitmapData = CGBitmapContextGetData(bitmapCtx);
    CGContextRelease(bitmapCtx);
    if(bitmapData){
        //Why need to release independently?
        //This is very trouble some.
        //What if the data is automatically allocated by himself?
        free(bitmapData);
    }
    CGImageRelease(image);
    
}


@end
