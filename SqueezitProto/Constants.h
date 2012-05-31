//
//  Constants.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef SqueezitProto_Constants_h
#define SqueezitProto_Constants_h

#ifdef DEBUG
#define EZCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
EZDEBUG(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define EZCONDITIONLOG(condition, xx, ...) ((void)0)
#endif // #ifdef DEBUG


#ifdef DEBUG
#define EZDEBUG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define EZDEBUG(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

#define SecondsPerDay 86400

#define CoreDBName @"Tasks.sqlite"
#define CoreModelName @"Tasks"

#define CoreFetchResultCache @"Root"

typedef enum EZEnvironmentTraits {
    EZ_ENV_NONE = 0,
    EZ_ENV_FITTING = 1,
    EZ_ENV_READING = 2,
    EZ_ENV_LISTENING = 4,
    EZ_ENV_SOCIALING = 8, 
    EZ_ENV_FLOWING = 16,//Quite, private, 
    //For practice need this 
} EZEnvironmentTraits;

typedef enum EZWeekDayValue {
    SUNDAY = 1,
    MONDAY = 2,
    TUESDAY = 4,
    WEDNESDAY = 8,
    THURSDAY = 16,
    FRIDAY = 32,
    SATURDAY = 64,
    ALLDAYS = 127
} EZWeekDayValue;

//So far no use, This is serve as an documenting, mean I have experienced the idea of some task can cooperate with other task, for example: Telling joke task can parallelized with social activity. 
//Do NOT get it too complicated now. 
// Keep the system simple and elegant during this stage. 
// Add small traits like on iterative way, make the software more lean and organic. 
typedef enum EZTaskTraits {
    EZ_TASK_NONE = 0,
} EZTaskTraits;

#endif
