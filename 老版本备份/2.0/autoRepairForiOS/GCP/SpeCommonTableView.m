//
//  SpeCommonTableView.m
//  xxt_xj
//
//  Created by Points on 13-12-18.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "SpeCommonTableView.h"

@implementation SpeCommonTableView
- (void)dealloc
{
   
    self._footer = nil;
    self._header = nil;
  
  
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if(self)
    {
        self._header = [[[MJRefreshHeaderView alloc]init]autorelease];
        self._header.scrollView = self;
//        self._footer = [[[MJRefreshFooterView alloc]init]autorelease];;
//        self._footer.scrollView = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
       
            #if KEY_CHAT_WITH_WS
                    
                    
            #else
                    
                    self._header = [[[MJRefreshHeaderView alloc]init]autorelease];
                    self._header.scrollView = self;
                    
                    
            #endif
        
//            self._footer = [[[MJRefreshFooterView alloc]init]autorelease];;
//            self._footer.scrollView = self;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
              Style:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
 withViewController:(id<MJRefreshBaseViewDelegate>)VC
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        if(isNeedPullDownRefresh)
        {
            self._header = [[[MJRefreshHeaderView alloc]init]autorelease];
            self._header.scrollView = self;
            self._header.delegate = VC;
        }
        
        if(isNeesLoadMore)
        {
            self._footer = [[[MJRefreshFooterView alloc]init]autorelease];;
            self._footer.scrollView = self;
            self._footer.delegate = VC;
        }
    }
    return self;
}

@end
