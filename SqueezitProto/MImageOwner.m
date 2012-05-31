//
//  MImageOwner.m
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MImageOwner.h"
#import "Constants.h"

@implementation MImageOwner

@dynamic name;
@dynamic thumbNail;

@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	//NSData *data = UIImagePNGRepresentation(value);
    EZDEBUG(@"TransformValue get called, stack is: %@",[NSThread callStackSymbols]);
    NSString* currentValue = value;
    const char* cstr = [currentValue cStringUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [[NSData alloc] initWithBytes:cstr length:strlen(cstr)];
	return data;
}


- (id)reverseTransformedValue:(id)value {
	//UIImage *uiImage = [[UIImage alloc] initWithData:value];
	//return [uiImage autorelease];
    EZDEBUG(@"ReverseTransformValue get called, stack is: %@",[NSThread callStackSymbols]);
    NSData* data = value;
    return [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
}

@end