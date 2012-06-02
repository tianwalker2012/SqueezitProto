//
//  EZTaskList.h
//  SqueezitProto
//
//  Created by Apple on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

// The purpose of this class, it just help people to organize their tasks.
// Previously I am thinking about use the TaskList to carry the Environment traits.
// This just a restriction. Why prevent people from lump any task into one list as long as 
// It make sense to them. 
// To somebody it mean freedom, while to other people it means choas and messy.
// They don't know how to organize things, they need restriction as guidance. 
// Appearantly, this type not my target audience.
// The value is hibernate provided a good API which could save people's time and energy to understand 
// Persistence layer. 
@class MTaskGroup;

@interface EZTaskGroup : NSObject<EZValueObject>

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSDate* createdTime;
@property(strong, nonatomic) NSMutableArray* tasks;
@property(strong, nonatomic) MTaskGroup* PO;

- (id) initWithPO:(MTaskGroup*)mtk;

- (MTaskGroup*) createPO;

- (MTaskGroup*) populatePO:(MTaskGroup*)po;

@end
