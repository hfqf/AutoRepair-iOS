
#ifndef JZH_Test_PublicADT_h
#define JZH_Test_PublicADT_h

typedef  enum MessageStatus
{
    ENUM_MESSAGESTATUS_FAILED = -1      ,//������澶辫触
    ENUM_MESSAGESTATUS_SENDING          ,//������涓�
    ENUM_MESSAGESTATUS_SUCCEED          ,//������������
    ENUM_MESSAGESTATUS_READED           , //宸茶��
    ENUM_MESSAGESTATUS_UNREAD           , //���璇�
    ENUM_MESSAGESTATUS_UNKNOWN          //������
    
}ENUM_MESSAGESTATUS;

typedef  enum MESSAGEFROM
{
    ENUM_MESSAGEFROM_OPPOSITE =0 ,//������澶辫触
    ENUM_MESSAGEFROM_SELF        ,//������涓�
    ENUM_MESSAGEFROM_UNKNOWN     ,//������
}ENUM_MESSAGEFROM;

typedef  enum MESSAGETYPE
{
    ENUM_MSG_TYPE_TEXT = 1          ,//������
    ENUM_MSG_TYPE_AUDIO             ,//��抽��
    ENUM_MSG_TYPE_PIC               ,//��剧��
    ENUM_MSG_TYPE_HOMEWORK          ,//瀹跺涵浣�涓�
    ENUM_MSG_TYPE_NOTICE            ,//������
    ENUM_MSG_TYPE_LOCATION          ,//浣�缃� 
    ENUM_MSG_TYPE_ALL               ,//������娑����
    ENUM_MSG_TYPE_EXCEPTHOMEWIRK    ,//��や��浣�涓�������
    ENUM_MSG_TYPE_UNKNOWN
}ENUM_MSG_TYPE;

typedef  enum CHAT_TYPE
{
    ENUM_CHAT_TYPE_SINGLE = 0 ,//������
    ENUM_CHAT_TYPE_GROUP      ,//缇ょ�����澶�
    ENUM_CHAT_TYPE_UNKNOWN    //������
}ENUM_CHAT_TYPE;

typedef enum  TYPE_IN_VIEWCONTROLLER
{
    TYPE_IN_MESSAGECENTER = 0, //娑����涓�蹇�
    TYPE_IN_HOMWWROK,          //浣�涓�������
    TYPE_IN_CHATINGROUP,       //���绾ц��澶�
    TYPE_IN_SYSTEMSETTING      //绯荤��璁剧疆
}
ENUM_TYPE_IN_VC;

typedef enum  TIMELAB_STATE
{
    ENUM_TIMELAB_STATE_HIDDEN  = 0,
    ENUM_TIMELAB_STATE_SHOW
}
ENUM_TIMELAB_STATE;

typedef enum LoginUser_Role_Type
{
    ENUM_LOGINER_ROLE_TEACHER = 0,
    ENUM_LOGINER_ROLE_PARENT
}
ENUM_LOGINER_ROLE_TYPE;

#define  USER_ROLE_TEACHER     1   // 用户角色老师
#define  USER_ROLE_STUDENT     2   // 用户角色学生
#define  USER_ROLE_PARENT      3   // 用户角色家长

//���������浠剁�卞����朵欢绠变互�����惰��澶圭被���
typedef  enum INTERACTIVE_MSG_TYPE
{
    ENUM_INTERACTIVE_RECEIVED_MSG_WORKING       = 1,//���������淇�
    ENUM_INTERACTIVE_RECEIVED_MSG_INTERACTIVE   =2 ,//(瀵逛��瀹堕�垮氨������绯昏��甯�,瀵逛�����甯�灏辨��瀹堕�垮�����)
    ENUM_INTERACTIVE_RECEIVED_MSG_NOTICE        =3,//�����ュ�����
    ENUM_INTERACTIVE_RECEIVED_MSG_EVALUATION    =4 ,//璇�璇�
    ENUM_INTERACTIVE_RECEIVED_MSG_SCORE         = 5,//���缁�
    ENUM_INTERACTIVE_RECEIVED_MSG_HOMEWORK      = 6,//浣�涓�
    ENUM_INTERACTIVE_RECEIVED_MSG_SAFE          = 7,//骞冲�����淇�
    ENUM_INTERACTIVE_RECEIVED_MSG_FAV           = 8,//(���瀹堕�垮�ㄥ�舵�′����ㄧ����㈢��灏辨��浼�2:瀹舵�′�����;���甯�,��ㄥ�舵�′����ㄤ��2;��ㄦ�″�℃����′��1:���������淇�)
    ENUM_INTERACTIVE_RECEIVED_MSG_REPLY_PARENT  ,
    ENUM_INTERACTIVE_RECEIVED_MSG_REPLY_TEACHER ,
    ENUM_INTERACTIVE_RECEIVED_MSG_PARENT_SEND,
    ENUM_INTERACTIVE_RECEIVED_MSG_SENDBOX,
    ENUM_INTERACTIVE_RECEIVED_MSG_RECEIVEBOX,
    ENUM_INTERACTIVE_RECEIVED_MSG_WORKING_FAV,
    ENUM_INTERACTIVE_RECEIVED_MSG_NONE,             //娌℃��绫诲��
}ENUM_INTERACTIVE_MSG_TYPE;

typedef enum UnreadNumType
{
    ENUM_UNREAD_TOTAL  =0,
    ENUM_UNREAD_JOB,
    ENUM_UNREAD_SAFE,
    ENUM_UNREAD_NOTICE ,
    ENUM_UNREAD_HOMEWORK,
    ENUM_UNREAD_SCORE,
    ENUM_UNREAD_RAMAK,
    ENUM_UNREAD_PARENTMSG,
    ENUM_UNREAD_CHAT,
    ENUM_UNREAD_NONE
}ENUM_UNREAD_MESSAGE_TYPE;

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,
} EGOPullRefreshState;

typedef enum {
    enum_dy_type_all = 0,    //��ㄩ�ㄧ�����
    enum_dy_type_myquestion, //���������棰�
    enum_dy_type_myasnwer,   //���������绛�
    enum_dy_type_myfav        //��������惰��
}ENUM_DATA_TYPE;

/**
 *  动态、说说、相册、日志选项（全部，我的，好友的）
 */
typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeAll   = 1,    ///< 动态、说说、相册、日志选项[全部]
    SelectTypeMe    = 2,    ///< 动态、说说、相册、日志选项[我的]
    SelectTypeOther = 3     ///< 动态、说说、相册、日志选项[好友的]
};

/**
 *  资源类型
 */
typedef NS_ENUM(NSUInteger, StudySourceType) {
    StudySourceTypeVideo    = 1,  ///< 视频（flv
    StudySourceTypeDocument = 2,  ///< 文档（doc，doxc，ppt，pptx，pdf)
    StudySourceTypeAudio    = 3,  ///< 音频（mp3）
    StudySourceTypePicture  = 4   ///< 图片（png，jpg）
};


typedef enum SearchTYpe
{
    enum_search_all = 0,
    enum_search_friend ,
    enum_search_newsInfo,
    enum_search_video,
    enum_search_askAndAnswer
}enum_search_type;


typedef NS_ENUM(NSUInteger, ENUM_ROLE_TYPE) {
    ENUM_ROLE_TYPE_CREATER   = 0,    ///< 动态、说说、相册、日志选项[全部]
    ENUM_ROLE_TYPE_AUTOREPAIRER    = 1,    ///< 动态、说说、相册、日志选项[我的]
    ENUM_ROLE_TYPE_STORE = 2     ///< 动态、说说、相册、日志选项[好友的]
};

#endif
