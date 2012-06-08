//
//  EZGlobalLocalize.m
//  Squeezit
//
//  Created by Apple on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGlobalLocalize.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
NSLocale* EZCurrentLocale() {
    NSArray* languages = [NSLocale preferredLanguages];
    if (languages.count > 0) {
        NSString* currentLanguage = [languages objectAtIndex:0];
        return [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
        
    } else {
        return [NSLocale currentLocale];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* EZLocalizedString(NSString* key, NSString* comment) {
    static NSBundle* bundle = nil;
    if (nil == bundle) {
        NSString* path = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"Squeezit.bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    
    return [bundle localizedStringForKey:key value:key table:nil];
}
