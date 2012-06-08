//
//  EZGlobalLocalize.h
//  Squeezit
//
//  Created by Apple on 12-4-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Gets the current system locale chosen by the user.
 *
 * This is necessary because [NSLocale currentLocale] always returns en_US.
 */
NSLocale* EZCurrentLocale();

/**
 * @return A localized string from the Squeezit.bundle.
 */
NSString* EZLocalizedString(NSString* key, NSString* comment);