//
//  MZScheduledTask.m
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MScheduledTask.h"
#import "MTask.h"


@implementation MScheduledTask

@dynamic startTime;
@dynamic duration;
@dynamic envTraits;
@dynamic task;
@dynamic alarmNotification;
@dynamic name;
@dynamic alarmType;
@end

//The purpose of this class is to make the LocalNotification persistentable.
@implementation NotificationConverter


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	//NSData *data = UIImagePNGRepresentation(value);
    
	return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value {
	//UIImage *uiImage = [[UIImage alloc] initWithData:value];
	//return [uiImage autorelease];
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
    
}

@end
