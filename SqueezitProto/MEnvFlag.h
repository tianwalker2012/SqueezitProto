//
//  MEnvFlag.h
//  SqueezitProto
//
//  Created by Apple on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MEnvFlag : NSManagedObject

@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * deleted;

@end
