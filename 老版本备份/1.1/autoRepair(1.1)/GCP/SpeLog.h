//
//  SpeLog.h
//  JZH_BASE
//
//  Created by Points on 13-11-22.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#ifndef JZH_BASE_SpeLog_h
#define JZH_BASE_SpeLog_h

#ifdef DEBUG
#define SpeLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define SpeLog(format, ...) NSLog(format, ## __VA_ARGS__)
#endif
#endif


#ifdef DEBUG
#define SpeAssert(e) assert(e)
#else
#define SpeAssert(e)
#endif

