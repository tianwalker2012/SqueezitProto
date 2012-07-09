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

- (void)drawRect:(CGRect)rect
{
    EZDEBUG(@"drawRect get called");
    CGRect myBoundingBox = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextRef bitmapCtx = [self createBitmapContext:myBoundingBox.size];
    CGContextSetRGBFillColor(bitmapCtx, 1, 1, 1, 1);
    CGContextFillRect(bitmapCtx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextSetRGBFillColor(bitmapCtx, 1, 0, 0, 1);
    CGContextFillRect(bitmapCtx, CGRectMake(0, 0, 50, 50));
    CGContextSetRGBFillColor(bitmapCtx, 0, 1, 0, 1);
    CGContextFillRect(bitmapCtx, CGRectMake(10, myBoundingBox.size.height - 60, 50, 50));
    CGImageRef image = CGBitmapContextCreateImage(bitmapCtx);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, myBoundingBox, image);
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
