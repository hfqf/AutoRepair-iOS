//
//  PublicDefine.h
//  XXT_xinjiang
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#ifndef  XXT_xinjiang_PublicDefine_h
#define  XXT_xinjiang_PublicDefine_h


#define  KEY_IS_DEV                                 0 //是否是测试环境
#define  KEY_IS_DEVICE                              0 //是否是真机运行
#define  KEY_IS_PRODUCT_SERVER                      1 //是否是正式商用环境，否则是欲上线正式环境

#define  SERVER                       KEY_IS_DEV ?( KEY_IS_DEVICE ? @"http://192.168.30.17:18080" : @"http://localhost:18080")   :          (KEY_IS_PRODUCT_SERVER ? @"http://autorepairhelper.duapp.com" :@"http://autoreview.duapp.com")
#define  JPUSH_APPKEY                 @"2c333bb853fee953412917d3"
#define  JPUSH_SECRET                 @"78b67cb91bdd80f8c0fa92a9"

#define  BOS_SERVER                   @"http://autorepaier.bj.bcebos.com"
#define  OS_TYPE                      @"ios"
#define  VERSION                      [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]
#define  PUSH_ID                      [JPUSHService registrationID] == nil ? @"" : [JPUSHService registrationID]


#pragma  mark - end

#define  IS_FIRST_LAUNCH               @"IS_FIRST_LAUNCH"
#define  NOT_FIRST_LAUNCH              @"NOT_FIRST_LAUNCH"

#define  HEIGHT_MAIN_BOTTOM            49

#define  MAIN_HEIGHT                  [UIScreen mainScreen].bounds.size.height
#define  MAIN_WIDTH                   [UIScreen mainScreen].bounds.size.width
#define  MAIN_FRAME                   [UIScreen mainScreen].bounds

#define   PUBLIC_BACKGROUND_COLOR         KEY_COMMON_BLUE_CORLOR //  UIColorFromRGB([ConverUtil getCurrentSkin])
#define  KEY_COMMON_CORLOR                   PUBLIC_BACKGROUND_COLOR
#define  KEY_DELETE_CORLOR                  UIColorFromRGB(0xFA8072)
#define  KEY_COMMON_BLUE_CORLOR                   UIColorFromRGB(0x4da8f1)
#define  KEY_COMMON_LIGHT_BLUE_CORLOR                   UIColorFromRGB(0xb2e3f9)
#define  KEY_COMMON_RED_CORLOR                   UIColorFromRGB(0XF44336)
#define  KEY_COMMON_GREEN_CORLOR                   UIColorFromRGB(0X4CAF50)
#define  KEY_COMMON_GRAY_CORLOR             UIColorFromRGB(0x787878)

#define  PUBLIC_RELEASE(id) \
{\
[id release];\
id = nil;\
}

#define  HEIGHT_SEGEMENT_RES           30
#define  HEIGHT_NAVIGATION             44
#define  HEIGHT_STATUSBAR              20

#define  OS_ABOVE_IOS8                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? 1 : 0)

#define  OS_ABOVE_IOS7                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 1 : 0)
#define  OS_ABOVE_IOS6                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

#define  SCREEN_EQUAL_480              (MAIN_HEIGHT == 480 ? YES :NO )
#define  DISTANCE_TOP                  ((OS_ABOVE_IOS7) ? 20 :0)

#define  CIRCLE_TOP                 ((OS_ABOVE_IOS7) ? 0 :20)
#define  HEIGTH_IS_ABOVE_480                  ((int)MAIN_HEIGHT >= 480)

#define  HEIGTH_IS_480                  ((int)MAIN_HEIGHT == 480)

/** 主线程执行方法 */
static inline void st_dispatch_async_main(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}
/** 主线程延时执行方法 */
static inline void st_dispatch_async_main_after(NSTimeInterval ti, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ti * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

/** 根据字符串、最大尺寸、字体计算字符串最合适尺寸 */
static inline CGSize CGSizeOfString(NSString * text, CGSize maxSize, UIFont * font) {
    CGSize fitSize;
    if(OS_ABOVE_IOS7)
    {
        fitSize = [text boundingRectWithSize:maxSize options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName: font} context:nil].size;
    }
    else
    {
        fitSize = [text sizeWithFont:font constrainedToSize:maxSize];
    }
    return fitSize;
}

static inline NSString *safeStringWith(id obj) {
    if (obj == nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", obj];
}

static inline NSString *StrFromObj(id obj) {
    if (obj == nil) {
        return nil;
    }
    if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber *num = (NSNumber *)obj;
        NSString *ret = [NSString stringWithFormat:@"%lld", [num longLongValue]];
        return ret;
    }
    else if([obj isKindOfClass:[NSString class]])
    {
        return obj;
    }
    else
    {
        return [NSString stringWithFormat:@"%@", obj];
    }
    return [NSString stringWithFormat:@"%@", obj];
}

/** 设置视图大小，原点不变 */
static inline void UIViewSetSize(UIView *view, CGSize size) { CGRect frame = view.frame; frame.size = size; view.frame = frame;}
/** 设置视图宽度，其他不变 */
static inline void UIViewSetSizeWidth(UIView *view, CGFloat width) { CGRect frame = view.frame; frame.size.width = width; view.frame = frame; }
/** 设置视图高度，其他不变 */
static inline void UIViewSetSizeHeight(UIView *view, CGFloat height) { CGRect frame = view.frame; frame.size.height = height; view.frame = frame; }
/** 设置视图原点，大小不变 */
static inline void UIViewSetOrigin(UIView *view, CGPoint pt) { CGRect frame = view.frame; frame.origin = pt; view.frame = frame; }
/** 设置视图原点x坐标，大小不变 */
static inline void UIViewSetOriginX(UIView *view, CGFloat x) { CGRect frame = view.frame; frame.origin.x = x; view.frame = frame; }
/** 设置视图原点y坐标，大小不变 */
static inline void UIViewSetOriginY(UIView *view, CGFloat y) { CGRect frame = view.frame; frame.origin.y = y; view.frame = frame; }
/** 设置视图中心x坐标，大小不变 */
static inline void UIViewSetCenterX(UIView *view, CGFloat x) { CGPoint pt = view.center; pt.x = x; view.center = pt; }
/** 设置视图中心y坐标，大小不变 */
static inline void UIViewSetCenterY(UIView *view, CGFloat y) { CGPoint pt = view.center; pt.y = y; view.center = pt; }

#define  DURATION_IN_CHATVIEW          1   // 在规定分钟以内的所有消息用一个时间提示包括起来
#define  MAX_LOGIN_TIME                4//最大登陆时长,单位是s


//单例声明的公用函数
#define SINGLETON_FOR_HEADER(className) \
+ (className *)sharedInstance;

//单例实现的公用函数
#define SINGLETON_FOR_CLASS(className) \
+ (className *)sharedInstance { \
static className *shared = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared = [[self alloc] init]; \
}); \
return shared; \
}


//tabbar对应的名字
#define  TITLE_FIRST_TABITEM    @"家校互动"
#define  TITLE_SECOND_TABITEM   @"培训通"
#define  TITLE_THREE_TABITEM    @"学习应用"
#define  TITLE_FORTH_TABITEM    @"学习应用"
#define  TITLE_FIFTH_TABITEM    @"个人设置"

#define  TITLE_EDUCATION_PROTAL @"教育门户"

#define KEY_ACCOUTN             @"account"
#define KEY_PASSWORD            @"password"

#define KEY_ACTION              @"action"
#define KEY_KEYSTRING           @"keystring"
#define KEY_SITE_ID             @"site_id"
#define KEY_PAGE_SIZE           @"page_size"
#define KEY_PAGES               @"pages"
#define KEY_TOPIC_ID            @"topic_id"
#define KEY_MSG_ID              @"msg_id"

//当前登陆用户信息
#define  KEY_USER_TYPE              @"userType"
#define  KEY_CLASS_ID               @"CLASS_ID"
#define  KEY_ACCESSTOKEN            @"accessToken"
#define  KEY_BOOKVERSION            @"BOOKVERSION" //教材版本
#define  KEY_GREAD                  @"GRADE"       //年级
#define  KEY_IM_TOKEN               [NSString stringWithFormat:@"%@+IM_TOKEN",[LoginUserUtil loginIdToIm]]
#define  KEY_IM_MDSIGN              [NSString stringWithFormat:@"%@+KEY_IM_MDSIGN",[LoginUserUtil loginIdToIm]]

#define   IS_REQUEST_SUCCEED(id)\
{\
[[NSString stringWithFormat:@"%ld",[[id objectForKey:@"result"]longValue]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%ld",[[id objectForKey:@"ret"]longValue]] isEqualToString:@"0"] \
}


#define PAGE_SIZE_EDUCATION           @"25" //每页获取新闻的个数
#define SITE_ID_EDUCATION             @"1005100"//siteid



#define KEY_TEST_IM_CONTACT           1

#define     MAX_NUM_INPUTCHAR         300//最多输入的字符数



#define REGEX_KEY                     @"\\(#\\w*\\)"// @"\\[[\u4e00-\u9fa5]*\\]"

#define REGEX_EMOJI                   @"\\(#\\w*\\)" //替换查找(#xxx)格式的字符串 \(#[\u4e00-\u9fa5]*\)

#define REGEX_WEB                     @"\\[\\w*\\]"

#define   RECOED_AUDIO_MIN_INTERVAL   1  //录音最短时间间隔，1秒

#define   RECOED_AUDIO_MAX_INTERVAL   15 //录音最长时间

#define   HEIGHT_KEYBOARD             216

#define   FONT_SIZE 14

#define  COMMENT_FONT                 [UIFont systemFontOfSize:14]
#define  FONT_CLASS_DYNAMIC                 [UIFont systemFontOfSize:14]

#define SEPARATE_EMOJI                @"!-!-+"//用于分离含有emoji字符串的内容转化,便于输出在SETextView中

#define OBJECT_REPLACEMENT_CHAR       "\xef\xbf\xbc" //占位符

//聊天界面的TableViewCell的类型
#define CHAT_TEXT_CELL                @"TEXT_CELL"
#define CHAT_PICTURE_CELL             @"PICTURE_CELL"
#define CHAT_AUDIO_CELL               @"AUDIO_CELL"

#define MAX_LENGTH_CHAT_CELL          (MAIN_WIDTH-140)  //聊天界面cell的最大宽度

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#pragma mark -

#define KEY_DEFAULT_HEAD_IAMGE          [UIImage imageNamed:@"avatar_0"]
#define KEY_DEFAULT_CONTENT_IAMGE       [UIImage imageNamed:@"default_image"]
#define KEY_NO_IAMGE                    [UIImage imageNamed:@"new_default"]
#define KEY_IAMGE_LOADING               [UIImage imageNamed:@"common_image_load"]
#define KEY_ABLUM_DEFAULT_IAMGE         [UIImage imageNamed:@"common_no_image"]

#define KEY_MAX_NUM_PTOIC               140

#define WEIBO_PIC_WIDTH                 120
#define WEIBO_PIC_HEIGHT                74

#define  KEY_VALUE_TOKEN_OUTDATE               -10000
#define  KEY_NAME_TOKEN_OUTDATE                @"TOKEN_OUTDATE"

#define  HEIGHT_MAIN_HEADVIEW         60

#define KEY_SELECTED_YEAR  @"KEY_SELECTED_YEAR"
#define KEY_SELECTED_MONTH @"KEY_SELECTED_MONTH"
#define KEY_SELECTED_DAY @"KEY_SELECTED_DAY"

#define KEY_SELECTED_LOCATION_YEAR  @"KEY_SELECTED_LOCATION_YEAR"
#define KEY_SELECTED_LOCATION_MONTH @"KEY_SELECTED_LOCATION_MONTH"
#define KEY_SELECTED_LOCATION_DAY @"KEY_SELECTED_LOCATION_DAY"

#define  KEY_BOOKVERSION   @"BOOKVERSION" //教材版本
#define  KEY_GREAD         @"GRADE"       //年级
#define  KEY_BOOKVERSION_CONTENT @"KEY_BOOKVERSION_CONTENT"
#define  KEY_GREAD_CONTENT @"KEY_GREAD_CONTENT"

#define DownloadDirectory [NSString stringWithFormat:@"%@/download/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject], [LoginUserUtil accountOfInput]]

#define KEY_SQ_TOKEN    @"SQ_TOKEN"
#define KEY_SQ_USERID   @"SQ_SUER_ID"
#define KEY_SQ_CLAZZID   @"SQ_CLAZZ_ID"
#define KEY_SQ_HEADURL   @"KEY_SQ_HEADURL"

//上传至社区文件的路径
#define KEY_UPLOAD_SQ_PATH            @"/public/var/mobile"
#define KEY_SQ_UPLOAD_FILE_TYPE       @"KEY_SQ_UPLOAD_FILE_TYPE"

//刷新未读信息的个数
#define  KEY_REFRESH_UNREAD_NUM        @"REFRESH_UNREAD_NUM"
#define KEY_LAST_MESSAGE_INFO          @"LAST_MESSAGES"
#define KEY_CURRENT_MESSAGE_INFO       @"CURRENT_MESSAGES"

#define KEY_UNREAD_TOTAL               @"homemsg_count"
#define KEY_UNREAD_HOMEWORK            @"homework_count"
#define KEY_UNREAD_JOB                 @"jobmsg_count"
#define KEY_UNREAD_NOTICE              @"notice_count"
#define KEY_UNREAD_REMARK              @"remark_count"
#define KEY_UNREAD_SAFE                @"safemsg_count"
#define KEY_UNREAD_SCORE               @"score_count"
#define KEY_UNREAD_PARENT_REPLY               @"result"

#define KEY_REFRESH_UNREADNUM_TIMEOUT  @"KEY_REFRESH_UNREADNUM_TIMEOUT"
#define KEY_SELECT_TIMEOUT_ROW        @"KEY_SELECT_TIMEOUT_ROW"

#define HEIGHT_STUYDR_RES_CELL        50

#pragma mark - 换肤
#define KEY_CHANAGE_SKIN                @"KEY_CHANAGE_SKIN"
#define KEY_IMAGE_FOR_VC_BACKGROUND             [NSString stringWithFormat:@"%@%@",[LoginUserUtil nameOfCurrentLoginer],@"KEY_IMAGE_FOR_VC_BACKGROUND"]//控制器背景图片
#define KEY_IMAGE_FOR_NAVIGATION_BACKGROUND   [NSString stringWithFormat:@"%@%@",[LoginUserUtil nameOfCurrentLoginer],@"KEY_IMAGE_FOR_NAVIGATION_BACKGROUND"]  //导航栏的背景图片

#define IMAGE_VC_BACKGROUND         [UIImage imageNamed:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_IMAGE_FOR_VC_BACKGROUND]]
#define IMAGE_NAVIGATION_BACKGROUND        [UIImage imageNamed:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_IMAGE_FOR_NAVIGATION_BACKGROUND]]

#define KEY_UPDATE_HEAD                @"KEY_UPDATE_HEAD"

#pragma mark - 收藏和群组

#define KEY_TOKEN_COLLECTGROUP        @"COLLECTANDGROUP" //TOKEN
#define KEY_CURRENT_ID_COLLECTGROUP   @"ID_COLLECTANDGROUP"
#define KEY_PROVICE_COLLECTGROUP      @"KEY_PROVICE_COLLECTGROUP"


#define KEY_REFRESH_CHAT_NUM          @"KEY_REFRESH_CHAT_NUM"

#define KEY_IS_OUTDEATE_TOKEN         @"KEY_IS_OUTDEATE_TOKEN"

#define KEY_UPLOAD_SCORE              @"KEY_UPLOAD_SCORE"
#define KEY_NAME_SUBJECT              @"KEY_NAME_SUBJECT"

#define KEY_REMOTEID                   @"KEY_REMOTEID"
#define KEY_LOGINID_IMTOKEN            @"KEY_LOGINID_IMTOKEN"
#define BAIDUMAP_STATIC_SNAP(longitude,latitude) [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%@,%@&width=120&height=80&zoom=12&&markers=%@,%@&markerStyles=-1,http://api.map.baidu.com/images/marker_red.png,-1",longitude,latitude,longitude,latitude]


#define KEY_PUSH_NAME                 @"KEY_NAME_PUSHTAB"
#define KEY_PUSH_ICON_URL           @"KEY_ICON_URL_PUSH"
#define KEY_PUSH_URL                @"KEY_PUSH_URL"

#define HTTP_MANAGER             [HttpConnctionManager sharedInstance]
#define IM_MANAGER                   [IMServerManager sharedInstance]

#define WIDTH_CIRCLE_TEXT            (MAIN_WIDTH-60)

#define  KEY_GARDEN_MAX_HEIGHT       100
#define  KEY_GARDEN_MAX_WIDTH        100

#define PAGESIZE 30
#define HEIGHT_INPUT    53

#define KEY_USERID            [LoginUserUtil userId]

#define KEY_WIDTH_SCROLLER_PIC    (MAIN_WIDTH-30)

#define KEY_STATE_SOUND_TIP      @"KEY_STATE_SOUND_TIP"
#define KEY_STATE_SHAKE_TIP      @"KEY_STATE_SHAKE_TIP"

#define FAILED_BLOCK      ^(AFHTTPRequestOperation *response, NSError *error)
#define  SHOW_ERROR_TIP         [PubllicMaskViewHelper showTipViewWith:[error localizedDescription] inSuperView:self.view withDuration:1];


#define SUCCEED_BLOCK     ^(NSDictionary *retDic)

#define KEY_SLIDER_WIDTH (MAIN_WIDTH-120)

#define KEY_LOGINER_ROLE        @"KEY_LOGINER_ROLE"

#pragma mark - 注册时需要字段

#define  KEY_REGISTER_IS_XXT                   @"KEY_REGISTER_IS_XXT"
#define  KEY_REGISTER_TEL                     @"KEY_TEL"
#define  KEY_REGISTER_ROLE                    @"KEY_ROLE"
#define  KEY_REGISTER_CLASS_ID_SCAN           @"KEY_CLASS_ID_SCAN"
#define  KEY_REGISTER_SCHOOL_ID                @"KEY_SCHOOL_ID"
#define  KEY_REGISTER_GRADE_ID                 @"KEY_GRADE_ID"
#define  KEY_REGISTER_GRADE_NAME                @"KEY_GRADE_NAME"
#define  KEY_REGISTER_CLASS_NAME                @"KEY_CLASS_NAME"
#define  KEY_REGISTER_CLASS_ID                 @"KEY_CLASS_ID"
#define  KEY_REGISTER_IS_SYNCHROUS             @"KEY_IS_SYNCHROUS"

#pragma mark - 登录时需要
#define  KEY_LOGIN_PROVICE_ID                  @"KEY_LOGIN_PROVICE_ID"
#define  KEY_LOGIN_ROLE                       @"KEY_LOGIN_ROLE"

#pragma mark - 设置通用开关
//接收消息
#define  KEY_ACCEPT_NEWS_SWITCH                @"KEY_ACCEPT_NEWS_SWITCH"
//声音
#define  KEY_VOICE_SWITCH                      @"KEY_VOICE_SWITCH"
//震动
#define  KEY_VIBRATION_SWITCH                  @"KEY_VIBRATION_SWITCH"
//聊一聊
#define  KEY_CHAT_SWITCH                       @"KEY_CHAT_SWITCH"
//加好友
#define  KEY_ADD_FRIEND_SWITCH                 @"KEY_ADD_FRIEND_SWITCH"
//群消息
#define  KEY_GROUP_INFORMATION_SWITCH          @"KEY_GROUP_INFORMATION_SWITCH"

#define  IS_FIRST_LAUNCH                       @"IS_FIRST_LAUNCH"
#define  NOT_FIRST_LAUNCH                      @"NOT_FIRST_LAUNCH"

#define  KEY_SELETED_CLASSID                   @"KEY_SELETED_CLASSID"


#define KEY_PUSH_DEVICE_TOKEN       @"KEY_PUSH_DEVICE_TOKEN"

#define SHOW_UNDONE_TIP                      [PubllicMaskViewHelper showTipViewWith:@"待完成" inSuperView:self.view withDuration:1];

// 界面中用到的灰色
#define GRAY_1 UIColorFromRGB(0xc4c4c4)
#define GRAY_2 UIColorFromRGB(0xe1dfdf)
#define GRAY_3 UIColorFromRGB(0xf0f0f0)

// 按钮颜色
#define ButtonDisableImage(size) [[UIImage imageWithCGSize:size color:GRAY_1 radius:BUTTON_CornerRadius] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
#define LoginNomalImage(size)  [[UIImage imageWithCGSize:size color:UIColorFromRGB(0x54c2ac) radius:BUTTON_CornerRadius] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
#define LoginHighlightedImage(size) [[UIImage imageWithCGSize:size color:UIColorFromRGB(0x44a995) radius:BUTTON_CornerRadius] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
#define RegisterNomalImage(size) [[UIImage imageWithCGSize:size color:UIColorFromRGB(0xa4c8f3) radius:BUTTON_CornerRadius] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
#define RegisterHighlightedImage(size) [[UIImage imageWithCGSize:size color:UIColorFromRGB(0x7ca4d4) radius:BUTTON_CornerRadius] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]

#define Login_Button_Height 40
#define Login_Input_Font [UIFont systemFontOfSize:14]
#define VCodeTimeInterval 45    ///< 二维码重发时间间隔
#define INPUT_ITEM_HEIGHT 48    ///< 输入框高度
#define INPUT_TOP_OFFSET  20    ///< 输入框距导航栏间距
#define INPUT_LEFT_OFFSET 20    ///< 输入框左侧距离

/////////////////////////// cell统一样式 ///////////////////////////////////
#define CELL_LEFT_OFFSET    10
#define CELL_Title_FONT     [UIFont systemFontOfSize:18.0]
#define CELL_Content_FONT   [UIFont systemFontOfSize:14.0]
#define CELL_Time_FONT      [UIFont systemFontOfSize:13.0]
#define CELL_TitleView_FONT [UIFont systemFontOfSize:14.0]
#define CELL_AVATAR_HEIGHT  40
#define CELL_TOP_OFFSET     10

/** 生成分割线 */
static inline UIView * SepLineWithFrame(CGRect frame) {
    UIImageView *sep = [[UIImageView alloc]initWithFrame:frame];
    [sep setBackgroundColor:[UIColor whiteColor]];
    sep.alpha = .3;
    return sep;
}


#define IOS_BULE UIColorFromRGB(0x0079ff)
#define NAV_RIGHT_BUTTON_FONT  [UIFont systemFontOfSize:16]

// 按钮圆角大小
#define BUTTON_CornerRadius 3.0
////////////////////////////////////////////////////////////////////////
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define is_iOS_7 ([[[[[UIDevice currentDevice]systemVersion]componentsSeparatedByString:@"."]objectAtIndex:0]intValue]>=7)
#define is_iPhone4_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define is_iPhone6_plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define is_iPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define is_iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define KEY_DISTANCE_HOMEWORK_CELL           20

#define KYY_HEIGHT_HOMEWORK_CELL             30

#define BOTTOM_Y    (SCREEN_HEIGHT - HEIGHT_NAVIGATION - HEIGHT_STATUSBAR)


/////////////////////////// 消息通知 ////////////////////////////////////

extern NSString *NotiCreateDailySuccess ;    ///< 创建日志成功
extern NSString *NotiSendAnswerSuccess ;    ///< 答疑回答问题成功
extern NSString *NotiAlbumUploadImageSuccess ;   ///< 相册上传照片成功
extern NSString *NotiAlbumDeleteImageSucess ;    ///< 相册删除照片成功
extern NSString *NotiAlbumCoverImageSetSucess ;    ///< 相册封面照片设置成功
extern NSString *NotiSendAskSuccess ;   ///< 提交问题成功，刷新列表
extern NSString  *NotiUploadAvatarSuccess ;   ///< 更新头像成功
extern NSString  *NotiAddNewClassSuccess ;   ///< 加入新的班级成功

#define KEY_NOTI_ADD_CLASS                          @"KEY_NOTI_ADD_CLASS" ///< 加入新的班级成功
#define KEY_FRIEND_REQ                             @"KEY_FRIEND_REQ" //好友申请数目

////////////////////////////////////////////////////////////////////////



#define KEY_LOCAL_NOTI_INFO                     @"KEY_LOCAL_NOTI_INFO"

#define KEY_HIGH_WEIBO                           ((KEY_WIDTH_SCROLLER_PIC-5)/2)

#define KEY_HIGH_NEWSCELL                         73.3


#pragma mark - 顾客
#define DB_Shared  [SqliteDataManager sharedInstance]
#define KEY_AUTO_NAME               @"KEY_AUTO_NAME"
#define KEY_AUTO_TEL                @"KEY_AUTO_TEL"
#define KEY_AUTO_LEVEL              @"KEY_AUTO_LEVEL"
#define KEY_AUTO_ID                 @"KEY_AUTO_ID"
#define KEY_AUTO_UDID_MODIFYED      @"KEY_AUTO_UDID_MODIFYED"
#define KEY_AUTO_HEAD               @"KEY_AUTO_HEAD"
#define KEY_AUTO_SHOP_NAME          @"KEY_AUTO_SHOP_NAME"
#define KEY_AUTO_ADDRESS            @"KEY_AUTO_ADDRESS"
#define KEY_AUTO_LOGIN              @"KEY_AUTO_LOGIN"
#define KEY_UDID                     [[UIDevice currentDevice]identifierForVendor].UUIDString.length == 0 ? @"0" :  [[UIDevice currentDevice]identifierForVendor].UUIDString


#define KEY_IS_TIPED_NEED_LOGIN     @"KEY_IS_TIPED_NEED_LOGIN" ///需要登录的说明
#define KEY_IS_FIRST_LOGIN          @"KEY_IS_FIRST_LOGIN" ///需要登录的说明
#define KEY_IS_CONTACT_AYSNED       @"KEY_IS_CONTACT_AYSNED" ///是否已经同步过所有数据
#define KEY_IS_REPAIR_AYSNED        @"KEY_IS_REPAIR_AYSNED" ///是否已经同步过所有数据

#define KEY_LOGINED_NAME            @"KEY_LOGINED_NAME"
#define KEY_LOGINED_PWD             @"KEY_LOGINED_PWD"

#define KEY_REPAIRS_SYNCED          @"KEY_REPAIRS_SYNCED"
#define KEY_REPAIRS_UPDATED         @"KEY_REPAIRS_UPDATED"
#pragma mark - EasyPR

#define  KEY_AUTO_ADD_CONTACT        @"KEY_AUTO_ADD_CONTACT"
#define  KEY_CURRENT_SKIN            @"KEY_CURRENT_SKIN"
