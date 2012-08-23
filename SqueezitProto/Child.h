//
//  Child.h
//  SqueezitProto
//
//  Created by Apple on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Parent;

@interface Child : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Parent *father;

@end
