//
//  Constants.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef SqueezitProto_Constants_h
#define SqueezitProto_Constants_h

typedef enum EZEnvironmentTraits {
    EZ_ENV_NONE = 0,
    EZ_ENV_QUITE = 1,
    EZ_ENV_STABLE = 2,
    EZ_ENV_PRIVATE = 4,
    EZ_ENV_OUTDOOR = 8 //For practice need this 
} EZEnvironmentTraits;


//So far no use, This is serve as an documenting, mean I have experienced the idea of some task can cooperate with other task, for example: Telling joke task can parallelized with social activity. 
//Do NOT get it too complicated now. 
// Keep the system simple and elegant during this stage. 
// Add small traits like on iterative way, make the software more lean and organic. 
typedef enum EZTaskTraits {
    EZ_TASK_NONE = 0,
} EZTaskTraits;

#endif
