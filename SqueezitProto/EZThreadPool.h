//
//  EZThreadPool.h
//  SqueezitProto
//
//  Created by Apple on 12-8-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZThreadPool : NSObject

+ (NSThread *) getWorkerThread;

@end
