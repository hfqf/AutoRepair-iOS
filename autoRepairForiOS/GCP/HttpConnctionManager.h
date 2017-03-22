//
//  HttpConnctionManager.h

@protocol HttpConnctionManagerDelegate <NSObject>

@optional


@end


#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"


@interface HttpConnctionManager : AFHTTPRequestOperationManager
{

}

@property(nonatomic,weak)id<HttpConnctionManagerDelegate>delegate;



SINGLETON_FOR_HEADER(HttpConnctionManager);

typedef void (^SuccessedBlock)(NSDictionary *succeedResult);

typedef void (^downFileSuccessedBlock)(NSString *lcoalPath);

typedef void (^FailedBlock)(AFHTTPRequestOperation *response, NSError *error);

typedef void (^FailBlock)(NSError *error);

#pragma mark - Public

- (void)startGetWith:( NSString *)url
            paragram:(NSDictionary *)para
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

//普通的post请求
- (void)startNormalPostWith:( NSString *)url
                   paragram:(NSDictionary *)para
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

//上传file类型的post请求
- (void)startMulitDataPost:( NSString *)url
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

#pragma mark - 登录注册



///测试函数
- (void)startTestHttp:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

///上传本地所有联系人
- (void)uploadAllContacts:(NSString *)str
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;

///上传本地所有维修记录
- (void)uploadAllRepairs:(NSString *)str
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;

///登录
- (void)startLoginWithName:(NSString *)name
                    withPwd:(NSString *)pwd
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

///注册
- (void)startRegisterWithName:(NSString *)name
                      withTel:(NSString *)tel
                    withPwd:(NSString *)pwd
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

///检查更新
- (void)checkUpdateVersion:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

#pragma mark - 联系人

///增加
- (void)addContact:(ADTContacterInfo *)newContact
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

///删除
- (void)deleteOneContact:(ADTContacterInfo *)contact
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

///更新
- (void)updateContact:(ADTContacterInfo *)contact
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

///获取所有联系人
- (void)queryAllContacts:(NSString *)owner
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

#pragma mark - 维修记录

///增加
- (void)addNewRepair:(ADTRepairInfo *)newRep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

///删除一条
- (void)delOneRepair:(ADTRepairInfo *)rep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

///删除所有
- (void)delAllRepair:(ADTRepairInfo *)rep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

///更新
- (void)updateOneRepair:(ADTRepairInfo *)rep
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

///获取所有维修记录
- (void)queryAllRepair:(NSString *)owner
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

- (void)uploadBOSFile:(NSString *)path
         withFileName:(NSString *)fileName
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;
@end
