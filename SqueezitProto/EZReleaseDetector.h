//
//  EZReleaseDetector.h
//  SqueezitProto
//
//  Created by Apple on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ DeAllocBlock)();
//The purpose of this class is to determine when and where the memory get released. 

@interface EZReleaseDetector : NSObject {
    NSDate* allocatedTime;
    NSString* name;
    BOOL hasStackTrace;
}

- (id) initWithName:(NSString*)nm hasStackTrace:(BOOL)stackTrace;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) DeAllocBlock block;

@end
