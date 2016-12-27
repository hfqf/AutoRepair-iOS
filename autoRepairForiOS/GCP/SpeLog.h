//
//  SpeLog.h
//  JZH_BASE
//
//  Created by Points on 13-11-22.
//  Copyright (c) 2013年 Points. All rights reserved.
//



#if DEBUG
#define SpeLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define SpeLog(format, ...)
#endif

