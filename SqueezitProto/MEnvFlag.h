//
//  MEnvFlag.h
//  SqueezitProto
//
//  Created by Apple on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MEnvFlag : NSManagedObject

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSNumber* flag;

@end
