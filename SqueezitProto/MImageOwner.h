//
//  MImageOwner.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ImageToDataTransformer : NSValueTransformer {
}
@end

@interface MImageOwner : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id thumbNail;

@end
