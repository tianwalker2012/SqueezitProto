//
//  EZCoreHelper.h
//  SqueezitProto
//
//  Created by Apple on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EZCoreHelper : NSObject

+ (void) removeByID:(NSManagedObjectID*)oid array:(NSMutableArray*)list; 

@end
