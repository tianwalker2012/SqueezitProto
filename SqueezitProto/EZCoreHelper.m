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
    for(int i = 0; i< [list count] ; i++){
        NSManagedObject* obj = [list objectAtIndex:i];
        if([obj.objectID isEqual:oid]){
            [list removeObject:obj];
            break;
        }
    }
}

@end
