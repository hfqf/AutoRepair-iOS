

#import "HttpConnctionManager.h"
#import "JPUSHService.h"
@implementation HttpConnctionManager

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:SERVER]];
    if(self)
    {
        [self.operationQueue setMaxConcurrentOperationCount:10];
        AFHTTPRequestSerializer * serial = [[AFHTTPRequestSerializer alloc]init];
        [serial setValue:@"application/json" forHTTPHeaderField: @"Content-type"];
        [self setRequestSerializer:serial];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [self setResponseSerializer:responseSerializer];
    }   
    return self;
}

SINGLETON_FOR_CLASS(HttpConnctionManager)

#pragma mark - 封装过的网络请求接口

- (void)startGetWith:( NSString *)url
            paragram:(NSDictionary *)para
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    AFHTTPRequestOperation *  operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             id res  = [operation.responseString objectFromJSONString];
             success((NSDictionary *)res);
         }
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(operation, error);
         }
     }
     ];
    [operation start];
}

- (void)startNormalDelete:( NSString *)url
                 paragram:(NSDictionary *)para
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed
{
    [self DELETE:url
   parameters:para
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SpeLog(@"error==%@",error);
         
         if (failed) {
             failed(operation,error);
         }
     }
     ];
}


- (void)startNormalGetWith:( NSString *)url
            paragram:(NSDictionary *)para
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self GET:url
    parameters:para
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {

         SpeLog(@"responseObject==%@",responseObject);

         success(responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SpeLog(@"error==%@",error);
         
         if (failed) {
             failed(operation,error);
         }
     }
     ];
}

//普通的post请求
- (void)startNormalPostWith:( NSString *)url
                   paragram:(NSDictionary *)para
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self POST:url == nil ? @"" : url
    parameters:para
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         SpeLog(@"responseObject==%@",responseObject);
         success(responseObject);
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         SpeLog(@"error==%@",error);
         
         if (failed) {
             failed(operation,error);
         }
     }
     ];
}

//上传file类型的post请求
- (void)startMulitDataPost:( NSString *)url
                  postFile:(NSData *)uploadFileData
                  paragram:(NSDictionary *)para
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self POST:url
    parameters:para
constructingBodyWithBlock:^(id <AFMultipartFormData> formData)
     {
         if(uploadFileData)
         {
             [formData appendPartWithFileData:uploadFileData name:@"fileupload" fileName:@"pic.jpg" mimeType:@"image/jpg"];
         }
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(success)
         {
             id res  = [operation.responseString objectFromJSONString];
             success((NSDictionary *)res);
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failed)
         {
             failed(nil, error);
         }
     }
     ];
}


#pragma mark - Private Function

- (NSString *)valueForKey:(NSString *)key Response:(NSString *)response
{
    NSString* ret = nil;
    NSRange range = [response rangeOfString:key];
    NSUInteger valueLocation = (range.location + key.length + 3);
    if ((NSNotFound != range.location)
        && (valueLocation <= response.length))
    {
        NSString* tmp = [response substringFromIndex:valueLocation];
        NSRange endrange = [tmp rangeOfString:@"\""];
        ret = [tmp substringToIndex:endrange.location];
    }
    
    return ret;
}

- (NSString *)valueForKey:(NSString *)key Valuelen:(NSUInteger)len Response:(NSString *)response
{
    NSString* ret = nil;
    NSRange range = [response rangeOfString:key];
    NSUInteger valueLocation = (range.location + key.length + 2);
    if ((NSNotFound != range.location)
        && (valueLocation <= response.length))
    {
        ret = [response substringWithRange:NSMakeRange(valueLocation, len)];
    }
    return ret;
}

#pragma mark -  mime-type detection
/**
 根据路径自动获取上传文件需要的miniType,contentType
 */
- (void)transferWithFileName:(NSString **)fileName andContentType:(NSString **)contentType filePath:(NSString *)filePath
{
    if (!*fileName) {
        *fileName = [filePath lastPathComponent];
    }
    if (!*contentType) {
        *contentType = [HttpConnctionManager mimeTypeForFileAtPath:filePath];
    }
}

//  mime-type detection
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)MIMEType;
}

#pragma mark - 测试函数

///测试函数
- (void)startTestHttp:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    [self startNormalGetWith:@"/users/get" paragram:nil successedBlock:success failedBolck:failed];
}

///上传本地所有联系人
- (void)uploadAllContacts:(NSString *)str
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/async/contact2" paragram:@{
                                                              @"contact"  : str
                                                              } successedBlock:success failedBolck:failed];
}

///上传本地所有维修记录
- (void)uploadAllRepairs:(NSString *)str
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/async/repair2" paragram:@{
                                                           @"repair"  : str
                                                           } successedBlock:success failedBolck:failed];
}

///登录
- (void)startLoginWithName:(NSString *)name
                   withPwd:(NSString *)pwd
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/users/login2" paragram:@{
                                                          @"username"  : name,
                                                          @"pwd":pwd,
                                                          @"udid":KEY_UDID,
                                                          @"ostype":OS_TYPE,
                                                          @"version":VERSION,
                                                          @"pushid":PUSH_ID
                                                          } successedBlock:success
                                                failedBolck:failed];
}

///注册
- (void)startRegisterWithName:(NSString *)name
                      withTel:(NSString *)tel
                      withPwd:(NSString *)pwd
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    
    
    [self startNormalPostWith:@"/register/addNewUser2"
                     paragram:@{
                                 @"username":name,
                                 @"pwd":pwd,
                                 @"tel":tel,
                                 @"viplevel":@"0",//暂时没有vip
                                 @"udid":KEY_UDID,
                                 @"ostype":OS_TYPE,
                                 @"version":VERSION
                                 }
               successedBlock:success
                  failedBolck:failed];
}

///检查更新
- (void)checkUpdateVersion:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self startNormalGetWith:@"/update/ios" paragram:nil successedBlock:success failedBolck:failed];
}

#pragma mark - 联系人

///增加
- (void)addContact:(ADTContacterInfo *)newContact
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/add" paragram:@{
                                                        @"carcode":newContact.m_carCode,
                                                        @"name":newContact.m_userName,
                                                        @"tel":newContact.m_tel,
                                                        @"cartype":newContact.m_carType,
                                                        @"owner":[LoginUserUtil userTel],
                                                        } successedBlock:success failedBolck:failed];
}

///删除
- (void)deleteOneContact:(ADTContacterInfo *)newContact
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/del2" paragram:@{
                                                        @"carcode":newContact.m_carCode,
                                                        @"name":newContact.m_userName,
                                                        @"tel":newContact.m_tel,
                                                        @"cartype":newContact.m_carType,
                                                        @"owner":[LoginUserUtil userTel],
                                                        @"id":newContact.m_idFromServer
                                                        } successedBlock:success failedBolck:failed];

}

///更新
- (void)updateContact:(ADTContacterInfo *)newContact
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/update2" paragram:@{
                                                           @"carcode":newContact.m_carCode,
                                                           @"name":newContact.m_userName,
                                                           @"tel":newContact.m_tel,
                                                           @"cartype":newContact.m_carType,
                                                           @"owner":[LoginUserUtil userTel],
                                                           @"id":newContact.m_idFromServer
                                                           } successedBlock:success failedBolck:failed];

}


///获取所有联系人
- (void)queryAllContacts:(NSString *)owner
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/queryAll"
                     paragram:@{
                                @"owner":owner
                                }
               successedBlock:success
                  failedBolck:failed];
    
}

#pragma mark - 维修记录

///增加
- (void)addNewRepair:(ADTRepairInfo *)newRep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/add2" paragram:@{
                                                         @"id":@"",
                                                         @"carcode":newRep.m_carCode,
                                                         @"totalkm":newRep.m_km,
                                                         @"repairetime":newRep.m_time,
                                                         @"addition":newRep.m_more,
                                                         @"tipcircle":newRep.m_targetDate,
                                                         @"isclose":newRep.m_isClose ? @"1" : @"0",
                                                         @"circle":newRep.m_repairCircle,
                                                         @"repairtype":newRep.m_repairType,
                                                         @"isreaded":newRep.m_isClose ? @"1" : @"0",
                                                         @"owner":[LoginUserUtil userTel],
                                                         @"inserttime":newRep.m_insertTime
                                                         } successedBlock:success failedBolck:failed];
}

///删除一条
- (void)delOneRepair:(ADTRepairInfo *)newRep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/del" paragram:@{
                                                        @"id":newRep.m_idFromNode,
                                                        @"owner":[LoginUserUtil userTel]

                                                        } successedBlock:success failedBolck:failed];
}

///删除所有
- (void)delAllRepair:(ADTRepairInfo *)newRep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/delAll" paragram:@{
                                                        @"carcode":newRep.m_carCode,
                                                        @"owner":[LoginUserUtil userTel]

                                                        } successedBlock:success failedBolck:failed];
}

///更新
- (void)updateOneRepair:(ADTRepairInfo *)newRep
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/update" paragram:@{
                                                           @"id":newRep.m_idFromNode,
                                                           @"carcode":newRep.m_carCode,
                                                           @"totalkm":newRep.m_km,
                                                           @"repairetime":newRep.m_time,
                                                           @"addition":newRep.m_more,
                                                           @"tipcircle":newRep.m_targetDate,
                                                           @"isclose":newRep.m_isClose ? @"1" : @"0",
                                                           @"isreaded":newRep.m_isClose ? @"1" : @"0",

                                                           @"circle":newRep.m_repairCircle,
                                                           @"repairtype":newRep.m_repairType,
                                                           @"owner":[LoginUserUtil userTel],
                                                           @"inserttime":newRep.m_insertTime
                                                           } successedBlock:success failedBolck:failed];
}

///获取所有记录
- (void)queryAllRepair:(NSString *)owner
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/queryAll"
                     paragram:@{
                                @"owner":owner
                                }
               successedBlock:success
                  failedBolck:failed];
    
}

@end
