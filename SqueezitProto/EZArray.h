//
//  EZArray.h
//  SqueezitProto
//
//  Created by Apple on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//What's the purpose of this class
//The just including a array within myself,
//So that I could use ARC to manage memory
@interface EZArray : NSObject {
    NSUInteger* uarray;
    int length;
}


- (id) initWithCapacity:(int)len;

- (id) initWithArray:(NSUInteger*)array length:(int)len;


@property (readonly, nonatomic) NSUInteger* uarray;
@property (readonly, nonatomic) int length;

@end
