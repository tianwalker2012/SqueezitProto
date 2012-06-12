//
//  EZEnvFlag.m
//  SqueezitProto
//
//  Created by Apple on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZEnvFlag.h"
#import "MEnvFlag.h"
#import "EZCoreAccessor.h"

@implementation EZEnvFlag
@synthesize flag, name, PO;

- (EZEnvFlag*) initWithName:(NSString*)nm flag:(NSUInteger)fg
{
    self = [super init];
    self.name = nm;
    self.flag = fg;
    return self;
}

- (id) initWithVO:(EZEnvFlag*) valueObj
{
    self = [super init];
    self.name = valueObj.name;
    self.flag = valueObj.flag;
    return self;
}

- (id) cloneVO
{
    return [[EZEnvFlag alloc] initWithVO:self];
}

- (id) initWithPO:(MEnvFlag*)mtk
{
    self = [super init];
    self.name = mtk.name;
    self.flag = mtk.flag.unsignedIntegerValue;
    return self;
}

- (NSManagedObject*) createPO
{
    if(!self.PO){
        self.PO = (MEnvFlag*)[[EZCoreAccessor getInstance] create:[MEnvFlag class]];
    }
    return [self populatePO:self.PO];
}

- (NSManagedObject*) populatePO:(MEnvFlag*)po
{
    po.name = self.name;
    po.flag = [[NSNumber alloc] initWithUnsignedInteger:self.flag];
    return po;
}

- (void) refresh
{
    if(self.PO){
        [self.PO.managedObjectContext refreshObject:self.PO mergeChanges:NO];
        self.name = self.PO.name;
        self.flag = self.PO.flag.unsignedIntegerValue;
    }

}




@end
