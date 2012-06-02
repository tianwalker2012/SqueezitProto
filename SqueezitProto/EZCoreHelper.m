//
//  EZCoreHelper.m
//  SqueezitProto
//
//  Created by Apple on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZCoreHelper.h"

@implementation EZCoreHelper

+ (void) removeByID:(NSManagedObjectID*)oid array:(NSMutableArray*)list
{
    for(NSManagedObject* obj in list){
        if([obj.objectID isEqual:oid]){
            [list removeObject:obj];
        }
    }
}

@end
