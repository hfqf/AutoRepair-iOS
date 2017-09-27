

#import "HttpConnctionManager.h"
#import "JPUSHService.h"
#import <BaiduBCEBOS/BaiduBCEBOS.h>
#import <BaiduBCEBasic/BaiduBCEBasic.h>
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
    NSString *isFirstLogin = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IS_FIRST_LOGIN];
    [self startNormalPostWith:@"/users/login3" paragram:@{
                                                          @"username"  : name,
                                                          @"pwd":pwd,
                                                          @"udid":KEY_UDID,
                                                          @"ostype":OS_TYPE,
                                                          @"version":VERSION,
                                                          @"pushid":PUSH_ID,
                                                          @"isfirstlogin":isFirstLogin == nil ? @"1" : @"0"
//                                                          @"isfirstlogin":@"1"
                                                          } successedBlock:success
                                                failedBolck:failed];
}

///注册
- (void)startRegisterWithName:(NSString *)name
                      withTel:(NSString *)tel
                      withPwd:(NSString *)pwd
                 withShopName:(NSString *)shopName
                  withAddress:(NSString *)address
                  withChannel:(NSString *)channel
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    
    
    [self startNormalPostWith:@"/register/addNewUser3"
                     paragram:@{
                                 @"username":name,
                                 @"pwd":pwd,
                                 @"tel":tel,
                                 @"viplevel":@"0",//暂时没有vip
                                 @"udid":KEY_UDID,
                                 @"ostype":OS_TYPE,
                                 @"version":VERSION,
                                 @"city":@"",
                                 @"downchannel":channel == nil ? @"" : channel,
                                 @"address":address==nil?@"":address,
                                 @"shopname":shopName==nil?@"":shopName,
                                 }
               successedBlock:success
                  failedBolck:failed];
}

///重置密码
- (void)regetPwd:(NSString *)tel
         withPwd:(NSString *)pwd
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/users/regetpwd"
                     paragram:@{
                                @"pwd":pwd,
                                @"tel":tel
                                }
               successedBlock:success
                  failedBolck:failed];
}

///更新头像
- (void)updateHead:(NSString *)headUrl
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/users/update"
                     paragram:@{
                                @"headurl":headUrl,
                                @"tel":[LoginUserUtil userTel]
                                }
               successedBlock:success
                  failedBolck:failed];
}

///更新姓名
- (void)updateUserName:(NSString *)userName
              shopName:(NSString *)shopName
               address:(NSString *)address
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/users/updateUserInfo"
                     paragram:@{
                                @"address":address,
                                @"shopname":shopName,
                                @"username":userName,
                                @"tel":[LoginUserUtil userTel]
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
    [self startNormalPostWith:@"/contact/add3" paragram:@{
                                                        @"carcode":newContact.m_carCode,
                                                        @"name":newContact.m_userName,
                                                        @"tel":newContact.m_tel,
                                                        @"cartype":newContact.m_carType,
                                                        @"owner":[LoginUserUtil userTel],
                                                        @"headurl":newContact.m_strHeadUrl == nil ? @"":newContact.m_strHeadUrl,
                                                        @"vin":newContact.m_strVin == nil ? @"": newContact.m_strVin,
                                                        @"carregistertime":newContact.m_strCarRegistertTime == nil ? @"" : newContact.m_strCarRegistertTime,
                                                        
                                                        } successedBlock:success failedBolck:failed];
}

///删除
- (void)deleteOneContact:(ADTContacterInfo *)newContact
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/del3" paragram:@{
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


///更新客户头像
- (void)updateCustomUrl:(ADTContacterInfo *)newContact
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/update3"
                     paragram:@{
                                @"carcode":newContact.m_carCode.length == 0 ? @"" :newContact.m_carCode,
                                @"name":newContact.m_userName.length == 0 ? @"" : newContact.m_userName,
                                @"tel":newContact.m_tel.length == 0 ? @"" :newContact.m_tel,
                             @"cartype":newContact.m_carType.length == 0 ? @"" : newContact.m_carType,
                             @"owner":[LoginUserUtil userTel],
                             @"id":newContact.m_idFromServer.length == 0 ? @"" :newContact.m_idFromServer,
                             @"isbindweixin":newContact.m_strIsBindWeixin.length == 0 ? @"" :newContact.m_strIsBindWeixin,
                             @"weixinopenid":newContact.m_strWeixinOPneid.length == 0 ? @"":newContact.m_strWeixinOPneid,
                             @"vin":newContact.m_strVin.length==0?@"":newContact.m_strVin,
                             @"carregistertime":newContact.m_strCarRegistertTime.length == 0 ? @"":newContact.m_strCarRegistertTime,
                             @"headurl":newContact.m_strHeadUrl.length==0?@"":newContact.m_strHeadUrl,
                             }
               successedBlock:success failedBolck:failed];
    
}


#pragma mark - 维修记录

///增加
- (void)addNewRepair:(ADTRepairInfo *)newRep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrItems = [NSMutableArray array];
    for(ADTRepairItemInfo *info in newRep.m_arrRepairItem)
    {
        [arrItems addObject:info.m_id];
    }
    [self startNormalPostWith:@"/repair/add3" paragram:@{
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
                                                         @"inserttime":newRep.m_insertTime,
                                                         @"items":arrItems
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
                                                        @"contactid":newRep.m_contactid,
                                                        @"owner":[LoginUserUtil userTel]

                                                        } successedBlock:success failedBolck:failed];
}

///更新
- (void)updateOneRepair:(ADTRepairInfo *)newRep
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrItems = [NSMutableArray array];
    for(ADTRepairItemInfo *info in newRep.m_arrRepairItem)
    {
        [arrItems addObject:info.m_id];
    }
    [self startNormalPostWith:@"/repair/update3" paragram:@{
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
                                                           @"inserttime":newRep.m_insertTime,
                                                           @"items":arrItems
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
///获取某个客户的所有记录
- (void)queryOneAllRepair:(NSString *)carcode
            withContactId:(NSString *)contactId
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/queryOneAll3"
                     paragram:@{
                                @"contactid":contactId,
                                @"carcode":carcode,
                                @"owner":[LoginUserUtil userTel]
                                }
               successedBlock:success
                  failedBolck:failed];
    
}


/**
 获取当前账单

 @param success
 @param failed
 */
- (void)queryTodayBills:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/getTodayBills"
                     paragram:@{
                                @"day":[LocalTimeUtil getLocalTimeWith:[NSDate date]],
                                @"owner":[LoginUserUtil userTel]
                                }
               successedBlock:success
                  failedBolck:failed];
    
}



- (void)queryAllTipedRepair:(NSString *)owner
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/queryAllTiped1"
                     paragram:@{
                                @"owner":owner
                                }
               successedBlock:success
                  failedBolck:failed];
    
}

- (void)clearOwnMoney:(NSString *)_id
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/clearownemoney"
                     paragram:@{
                                @"id":_id
                                }
               successedBlock:success
                  failedBolck:failed];

}

- (void)uploadBOSFile:(NSString *)path
         withFileName:(NSString *)fileName
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed
{
    NSString* ak = @"fd1a99ecacc646378349c9bf18ca63cf";
    NSString* sk = @"704ec5d754d1433ca6317ec09e263cd4";
    NSString* host = @"http://bj.bcebos.com";
    NSString* bucket = @"autorepaier";
    
    // step1: create a BOS client
    BCECredentials* credentials = [[BCECredentials alloc] init];
    credentials.accessKey = ak;
    credentials.secretKey = sk;
    
    BOSClientConfiguration* configuration = [[BOSClientConfiguration alloc] init];
    configuration.endpoint = host;
    configuration.credentials = credentials;
    
    BOSClient* client = [[BOSClient alloc] initWithConfiguration:configuration];
    
    // step2: prepare data
    BOSObjectContent* content = [[BOSObjectContent alloc] init];
    content.objectData.data = [NSData dataWithContentsOfFile:path];
    
    // step3: upload
    BOSPutObjectRequest* request = [[BOSPutObjectRequest alloc] init];
    request.bucket = bucket;
    request.key = [NSString stringWithFormat:@"%@_%@.png",[LoginUserUtil userTel],fileName];
;
    request.objectContent = content;
    
    __block BOSPutObjectResponse* response = nil;
    BCETask* task = [client putObject: request];
    task.then(^(BCEOutput* output) {
        if (output.progress) {
            NSLog(@"put object progress is %@", output.progress);
        }
        
        if (output.response) {
            response = (BOSPutObjectResponse*)output.response;
            NSLog(@"put object success!");
            success(@{@"code":@"1",
                      @"url":request.key
                      });
        }
        
        if (output.error) {
            NSLog(@"put object failure");
            success(@{
                      @"code":@"0",
                      @"msg":output.error.description
                      });
        }
    });
    [task waitUtilFinished];
    
    
    }


#pragma mark - 收费记录

- (void)addRepairItem:(ADTRepairItemInfo *)info
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed{
    [self startNormalPostWith:@"/repairitem/add" paragram:@{
                                                            @"repid":info.m_repid == nil ? @"" : info.m_repid,
                                                            @"contactid":info.m_contactid == nil ? @"" :info.m_contactid,
                                                           @"price":info.m_price,
                                                           @"num":info.m_num,
                                                           @"type":info.m_type,
                                                            @"itemtype":info.m_itemType,
                                                            @"goods":info.m_goodsId,
                                                            @"service":info.m_serviceId
                                                           }
               successedBlock:success
                  failedBolck:failed];
}


- (void)deleteRepairItem:(ADTRepairItemInfo *)info
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed{
    [self startNormalPostWith:@"/repairitem/del" paragram:@{
                                                            @"id":info.m_id,
                                                            }
               successedBlock:success
                  failedBolck:failed];
}

- (void)deleteRepairItems:(NSString *)contactId
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed{
    [self startNormalPostWith:@"/repairitem/delAll" paragram:@{
                                                            @"contactid":contactId
                                                            }
               successedBlock:success
                  failedBolck:failed];
}


- (void)queryAllRepairItem:(NSString *)repId
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repairitem/query" paragram:@{
                                                            @"repid":repId,
                                                            }
               successedBlock:success
                  failedBolck:failed];
}

- (void)addRepairItems:(NSArray *)arrItems
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repairitem/additems"
                     paragram:@{
                                  @"items":arrItems,
                              }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 3.2
- (void)getAllRepairsWithState:(NSString *)state
                      withPage:(NSInteger )page
                      withSize:(NSInteger )size
                     contactid:(NSString *)contactid
                       carCode:(NSString *)carCode
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    NSString *path = nil;
    if(state.integerValue == 4){
        path = @"/repair/queryAllWithStateAndOwned";
        state = @"2";
    }else{
        path = @"/repair/queryAllWithState";
    }
    [self startNormalPostWith:path
                     paragram:
                            (contactid == nil && carCode == nil) ?
                            @{
                              @"state":state,
                              @"pagesize":[NSString stringWithFormat:@"%ld",(long)size],
                              @"page":[NSString stringWithFormat:@"%ld",(long)page],
                              @"owner":[LoginUserUtil userTel],
                              }:
                             @{
                               @"state":state,
                               @"pagesize":[NSString stringWithFormat:@"%ld",(long)size],
                               @"page":[NSString stringWithFormat:@"%ld",(long)page],
                               @"owner":[LoginUserUtil userTel],
                               @"carcode":carCode,
                               @"contactid":contactid
                               }
               successedBlock:success
                  failedBolck:failed];
}


///增加
- (void)addNewRepair4:(ADTRepairInfo *)newRep
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrItems = [NSMutableArray array];
    for(ADTRepairItemInfo *info in newRep.m_arrRepairItem)
    {
        [arrItems addObject:info.m_id];
    }
    [self startNormalPostWith:@"/repair/add4" paragram:@{
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
                                                         @"inserttime":newRep.m_insertTime,
                                                         @"items":arrItems,
                                                         @"contactid":newRep.m_contactid,
                                                         @"wantedcompletedtime":newRep.m_wantedcompletedtime,
                                                         @"customremark":newRep.m_customremark,
                                                         @"iswatiinginshop":newRep.m_iswatiinginshop,
                                                         @"entershoptime":newRep.m_entershoptime,
                                                         
                                                         } successedBlock:success failedBolck:failed];
}


///更新
- (void)updateOneRepair4:(ADTRepairInfo *)newRep
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrItems = [NSMutableArray array];
    for(ADTRepairItemInfo *info in newRep.m_arrRepairItem)
    {
        [arrItems addObject:info.m_id];
    }
    [self startNormalPostWith:@"/repair/update5" paragram:@{
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
                                                            @"inserttime":newRep.m_insertTime,
                                                            @"items":arrItems,
                                                            @"contactid":newRep.m_contactid,
                                                            @"wantedcompletedtime":newRep.m_wantedcompletedtime,
                                                            @"customremark":newRep.m_customremark,
                                                            @"iswatiinginshop":newRep.m_iswatiinginshop,
                                                            @"entershoptime":newRep.m_entershoptime,
                                                            @"state":newRep.m_state,
                                                            @"ownnum":newRep.m_ownMoney == nil ? @"0" :  newRep.m_ownMoney
                                                            } successedBlock:success failedBolck:failed];
}


- (void)cancelRepair3:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/cancel"
                     paragram:@{
                               @"id":_id,
                               @"owner":[LoginUserUtil userTel],
                               }
               successedBlock:success
                  failedBolck:failed];
}

- (void)revertRepair3:(NSString *)_id
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/revert"
                     paragram:@{
                                @"id":_id,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateRepairState3:(NSString *)state
                   withId:(NSString *)_id
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/updateState"
                     paragram:@{
                                @"state":state,
                                @"id":_id,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)deleteOnesRepairs3:(NSString *)carcode
            withContactId:(NSString *)contactid
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/delAll3"
                     paragram:@{
                                @"contactid":contactid,
                                @"carcode":carcode,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)queryOnesRepairs3:(NSString *)carcode
             withContactId:(NSString *)contactid
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/queryOneAll3"
                     paragram:@{
                                @"contactid":contactid,
                                @"carcode":carcode,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)queryAllTipedRepairs3:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/repair/queryAllTiped1"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)queryCustomerOrders:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/getOrderRepairList"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateCustomerOrderWith:(NSString *)shopName
                     withOpenId:(NSString *)openId
                         withId:(NSString *)_id
                withConfirmTime:(NSString *)confirmTime
                  withOrderTime:(NSString *)orderTime
                  withOrderInfo:(NSString *)info
                      withState:(NSString *)state
                 successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/updateOrderRepair"
                     paragram:@{
                                @"shopname":shopName,
                                @"openid":openId,
                                @"id":_id,
                                @"confirmtime":[LocalTimeUtil getCurrentTime],
                                @"ordertime":orderTime,
                                @"orderinfo":info,
                                @"state":state,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)delCustomerOrder:(NSString *)_id
          successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/contact/delOrderRepair"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 3.5

#pragma mark - 库房管理

- (void)getAllWareHouseList:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouse/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewWarehouseWith:(NSString *)name
                 withRemark:(NSString *)remark
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouse/add"
                     paragram:@{
                                @"name":name,
                                @"desc":remark,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)delOneWarehouseWith:(NSString *)_id
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouse/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneWarehouseWith:(NSString *)name
                 withRemark:(NSString *)remark
                        withId:(NSString *)_id
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouse/update"
                     paragram:@{
                                @"name":name,
                                @"desc":remark,
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 库位管理
- (void)getAllWareHousePositionList:(NSString *)warehouseId
                     successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouseposition/query"
                     paragram:@{
                                @"warehouseid":warehouseId,
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewWarehousePositionWith:(NSString *)name
                         withRemark:(NSString *)remark
                    withWarehouseId:(NSString *)warehouseId
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouseposition/add"
                     paragram:@{
                                @"name":name,
                                @"desc":remark,
                                @"warehouseid":warehouseId,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)delOneWarehousePositionWith:(NSString *)_id
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouseposition/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneWarehousePositionWith:(NSString *)name
                    withRemark:(NSString *)remark
                        withId:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehouseposition/update"
                     paragram:@{
                                @"name":name,
                                @"desc":remark,
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 供应商管理

- (void)getAllSupplierList:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousesupplier/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewWarehouseSupplierWith:(NSString *)company
                           withName:(NSString *)name
                            withTel:(NSString *)tel
                        withAddress:(NSString *)address
                    withRemark:(NSString *)remark
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousesupplier/add"
                     paragram:@{
                                @"suppliercompanyname":company,
                                @"managername":name,
                                @"tel":tel,
                                @"address":address == nil ? @"" : address,
                                @"remark":remark == nil ? @""  :remark,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)delOneWarehouseSupplierWith:(NSString *)_id
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousesupplier/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneWarehouseSupplierWith:(NSString *)company
                              withName:(NSString *)name
                               withTel:(NSString *)tel
                           withAddress:(NSString *)address
                            withRemark:(NSString *)remark
                                withId:(NSString *)_id
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousesupplier/update"
                     paragram:@{
                                @"suppliercompanyname":company,
                                @"managername":name,
                                @"tel":tel,
                                @"address":address,
                                @"remark":remark,
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 商品分类(一级分类)

- (void)getAllGoodsTypePreviewList:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodstoptype/preview"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)getAllGoodsTopTypeList:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodstoptype/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewGoodsTopTypeWith:(NSString *)name
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodstoptype/add"
                     paragram:@{
                                @"name":name,
                                @"owner":[LoginUserUtil userTel],

                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)addNewGoodsTopTypeRefWith:(NSArray *)subId
                        withTopId:(NSString *)topId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodstoptype/addRef"
                     paragram:@{
                                @"id":topId,
                                @"subids":subId,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}



- (void)delOneGoodsTopTypeWith:(NSString *)_id
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodstoptype/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneGoodsTopTypeWith:(NSString *)name
                                withId:(NSString *)_id
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodstoptype/update"
                     paragram:@{
                                @"name":name,
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 商品分类(二级分类)

- (void)getAllGoodsSubTypeList:(NSString *)toptypeid
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodssubtype/query"
                     paragram:@{
                                @"toptypeid":toptypeid,
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewGoodsSubTypeWith:(NSString *)name
                     withTopId:(NSString *)topId
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodssubtype/add"
                     paragram:@{
                                @"name":name,
                                @"owner":[LoginUserUtil userTel],
                                @"toptypeid":topId
                                }
               successedBlock:success
                  failedBolck:failed];
}



- (void)delOneGoodsSubTypeWith:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodssubtype/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneGoodsSubTypeWith:(NSString *)name
                           withId:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodssubtype/update"
                     paragram:@{
                                @"name":name,
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}



#pragma mark - 商品

- (void)getAllGoodsList:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)getAllGoodsListWithType:(NSString *)subtype
         successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/query"
                     paragram: @{
                                 @"subtype":subtype == nil ? @"" : subtype,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)getGoodsInfo:(NSString *)goodsId
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/getGoodsInfo"
                     paragram:@{
                                @"goodsId":goodsId,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)addNewGoodsWith:(WareHouseGoods *)newGoods
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/add"
                     paragram:@{
                                @"subtype":safeStringWith(newGoods.m_category[@"_id"]),
                                @"picurl":safeStringWith(newGoods.m_picurl),
                                @"name":safeStringWith(newGoods.m_name),
                                @"goodsencode":safeStringWith(newGoods.m_goodsencode),
                                @"category":newGoods.m_category[@"_id"],
                                @"saleprice":safeStringWith(newGoods.m_saleprice),
                                @"costprice":safeStringWith(newGoods.m_costprice),
                                @"productertype":safeStringWith(newGoods.m_productertype).length == 0 ? @"0" : safeStringWith(newGoods.m_productertype) ,
                                @"producteraddress":safeStringWith(newGoods.m_producteraddress),
                                @"barcode":safeStringWith(newGoods.m_barcode),
                                @"brand":safeStringWith(newGoods.m_brand),
                                @"unit":safeStringWith(newGoods.m_unit),
                                @"minnum":safeStringWith(newGoods.m_minnum),
                                @"applycartype":safeStringWith(newGoods.m_applycartype),
                                @"remark":safeStringWith(newGoods.m_remark),
                                @"isactive":safeStringWith(newGoods.m_isactive).length == 0 ? @"1" : safeStringWith(newGoods.m_isactive) ,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneGoodsWith:(WareHouseGoods *)newGoods
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/update"
                     paragram:@{
                                @"picurl":safeStringWith(newGoods.m_picurl),
                                @"name":safeStringWith(newGoods.m_name),
                                @"goodsencode":safeStringWith(newGoods.m_goodsencode),
                                @"category":@[newGoods.m_category[@"_id"]],
                                @"saleprice":safeStringWith(newGoods.m_saleprice),
                                @"costprice":safeStringWith(newGoods.m_costprice),
                                @"productertype":safeStringWith(newGoods.m_productertype),
                                @"producteraddress":safeStringWith(newGoods.m_producteraddress),
                                @"barcode":safeStringWith(newGoods.m_barcode),
                                @"brand":safeStringWith(newGoods.m_brand),
                                @"unit":safeStringWith(newGoods.m_unit),
                                @"minnum":safeStringWith(newGoods.m_minnum),
                                @"applycartype":safeStringWith(newGoods.m_applycartype),
                                @"remark":safeStringWith(newGoods.m_remark),
                                @"isactive":safeStringWith(newGoods.m_isactive),
                                @"owner":[LoginUserUtil userTel],
                                @"id":newGoods.m_id,
                                @"subtype":safeStringWith(newGoods.m_category[@"_id"]),
                                }
               successedBlock:success
                  failedBolck:failed];
}


/**
 商品入库,只需要更新个别字段即可

 @param newGoods
 @param success
 @param failed
 */
- (void)saveBuyedOneGoodsWith:(WareHouseGoods *)newGoods
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSInteger systemPrice = (newGoods.m_num.floatValue*newGoods.m_systemPrice.floatValue+newGoods.m_purchaseNum.floatValue*newGoods.m_costprice.floatValue) /(newGoods.m_num.floatValue+newGoods.m_purchaseNum.floatValue);//系统价格，历次购买的平均价
    [self startNormalPostWith:@"/warehousegoods/savebuyed"
                     paragram:@{
                                @"position":[newGoods.m_storePosition stringWithFilted:@"_id"],
                                @"num":[NSString stringWithFormat:@"%lu", newGoods.m_purchaseNum.integerValue+newGoods.m_num.integerValue],//最新的存库数量
                                @"id":newGoods.m_id,
                                @"purchasenum":@"0",
                                @"systemprice":[NSString stringWithFormat:@"%lu",systemPrice]
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneGoodsPurchaseInfoWith:(WareHouseGoods *)newGoods
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/updatepurchase"
                     paragram:@{
                                @"costprice":newGoods.m_costprice,
                                @"purchasenum":newGoods.m_purchaseNum,
                                @"id":newGoods.m_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)updateOneGoodsForRejectWith:(WareHouseGoods *)newGoods
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/reject"
                     paragram:@{
                                @"num":newGoods.m_num,
                                @"id":newGoods.m_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneGoodsStoreNumWith:(ADTRepairItemInfo *)item
                         withIsOut:(BOOL)isOut
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/updatestorenum"
                     paragram:@{
                                @"num":item.m_num,
                                @"id":item.m_goodsId,
                                @"isout":isOut ? @"1" : @"0"
                                }
               successedBlock:success
                  failedBolck:failed];
}






- (void)delOneGoodsWith:(NSString *)_id
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 库存总览

- (void)getAllWarmingGoodsStoreList:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/querywaring"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)getAllGoodsStoreList:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoods/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewGoodsStoreWith:(WareHouseGoods *)goods
                    supplier:(NSString *)supplier
                         num:(NSString *)num
            warehouseposition:(NSString *)warehouseposition
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodsstore/add"
                     paragram:@{
                                @"goodsid":goods.m_id,
                                @"supplier":supplier,
                                @"num":num,
                                @"warehouseposition":warehouseposition,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)delOneGoodsStoreWith:(WareHouseGoods *)goods
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodsstore/del"
                     paragram:@{
                                @"id":goods.m_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}


#pragma mark - 采购
- (void)addNewPurchaseWith:(WarehousePurchaseInfo *)purchase
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrGoods = [NSMutableArray array];
    NSString *goodsid = nil;
    for(WareHouseGoods *good in purchase.m_arrGoods){
        [arrGoods addObject:good.m_id];
        goodsid = good.m_id;
    }
    [self startNormalPostWith:@"/warehousegoodspurchase/add"
                     paragram:@{
                                @"state":safeStringWith(purchase.m_state),
                                @"paytype":safeStringWith(purchase.m_payType),
                                @"expresscostpaytype":safeStringWith(purchase.m_expressPayType),
                                @"expresscompany":safeStringWith(purchase.m_expressCompany),
                                @"expressserialid":safeStringWith(purchase.m_expressSerialId),
                                @"expresscost":safeStringWith(purchase.m_expressCost),
                                @"supplier":purchase.m_supplier[@"_id"],
                                @"goods":arrGoods,
                                @"goodsid":goodsid,
                                @"remark":safeStringWith(purchase.m_remark),
                                @"owner":[LoginUserUtil userTel],
                                @"buyer":[LoginUserUtil userId],
                                @"num":safeStringWith(purchase.m_num),
                                @"price":safeStringWith(purchase.m_price),
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOnePurchaseWith:(WarehousePurchaseInfo *)purchase
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrGoods = [NSMutableArray array];
    NSString *goodsid = nil;
    for(WareHouseGoods *good in purchase.m_arrGoods){
        [arrGoods addObject:good.m_id];
        goodsid = good.m_id;
    }
    [self startNormalPostWith:@"/warehousegoodspurchase/update"
                     paragram:@{
                                @"state":safeStringWith(purchase.m_state),
                                @"paytype":safeStringWith(purchase.m_payType),
                                @"expresscostpaytype":safeStringWith(purchase.m_expressPayType),
                                @"expresscompany":safeStringWith(purchase.m_expressCompany),
                                @"expressserialid":safeStringWith(purchase.m_expressSerialId),
                                @"expresscost":safeStringWith(purchase.m_expressCost),
                                @"supplier":purchase.m_supplier[@"_id"],
                                @"goods":arrGoods,
                                @"goodsid":goodsid,
                                @"remark":safeStringWith(purchase.m_remark),
                                @"owner":[LoginUserUtil userTel],
                                @"buyer":[LoginUserUtil userId],
                                @"num":safeStringWith(purchase.m_num),
                                @"price":safeStringWith(purchase.m_price),
                                @"id":safeStringWith(purchase.m_id),
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)queryPurchaseGoods:(NSString *)state
            successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodspurchase/query"
                     paragram:@{
                                @"state":state,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)queryAllPurchaseGoods:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodspurchase/queryall"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)queryOnePurchaseGoodsInfo:(NSString *)goodsId
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodspurchase/queryone"
                     paragram:@{
                                @"goodsid":goodsId,
                                @"owner":[LoginUserUtil userTel],
                                @"state":@"1"
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)savePurchaseGoodsToStore:(WarehousePurchaseInfo *)purchase
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed
{
    NSMutableArray *arrGoods = [NSMutableArray array];
    for(WareHouseGoods *good in purchase.m_arrGoods){
        [arrGoods addObject:good.m_id];
    }
    [self startNormalPostWith:@"/warehousegoodspurchase/savetostore"
                     paragram:@{
                                @"id":purchase.m_id,
                                @"paytype":purchase.m_payType,
                                @"expresscost":purchase.m_expressCost,
                                @"goods":arrGoods,
                                @"saver":[LoginUserUtil userId]
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)rejectPurchaseGoodsToStore:(WarehousePurchaseInfo *)purchase
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodspurchase/reject"
                     paragram:@{
                                @"id":purchase.m_id,
                                @"rejectreason":purchase.m_rejectReason,
                                @"rejecter":[LoginUserUtil userId]
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 服务管理(一级分类)

- (void)getAllServiceTypePreviewList:(SuccessedBlock)success
                       failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicetoptype/preview"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)getAllServiceTopTypeList:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicetoptype/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewServiceTopTypeWith:(NSString *)name
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicetoptype/add"
                     paragram:@{
                                @"name":name,
                                @"owner":[LoginUserUtil userTel],

                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)addNewServiceTopTypeRefWith:(NSArray *)subId
                        withTopId:(NSString *)topId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicetoptype/addRef"
                     paragram:@{
                                @"id":topId,
                                @"subids":subId,
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}



- (void)delOneServiceTopTypeWith:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicetoptype/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneServiceTopTypeWith:(NSString *)name
                           withId:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicetoptype/update"
                     paragram:@{
                                @"name":name,
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 商品分类(二级分类)

- (void)getAllServiceSubTypeList:(NSString *)toptypeid
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicesubtype/query"
                     paragram:@{
                                @"toptypeid":toptypeid,
                                }
               successedBlock:success
                  failedBolck:failed];
}


- (void)addNewServiceSubTypeWith:(NSString *)name
                       withPrice:(NSString *)price
                     withTopId:(NSString *)topId
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicesubtype/add"
                     paragram:@{
                                @"name":name,
                                @"owner":[LoginUserUtil userTel],
                                @"toptypeid":topId,
                                @"price":price
                                }
               successedBlock:success
                  failedBolck:failed];
}



- (void)delOneServiceSubTypeWith:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicesubtype/del"
                     paragram:@{
                                @"id":_id,
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)updateOneServiceSubTypeWith:(NSString *)name
                          withPrice:(NSString *)price
                           withId:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/servicesubtype/update"
                     paragram:@{
                                @"name":name,
                                @"id":_id,
                                @"price":price
                                }
               successedBlock:success
                  failedBolck:failed];
}

#pragma mark - 出入库记录
- (void)addNewGoodsInOutRecoedeWith:(NSString *)type
                       withRemak:(NSString *)remark
                          withGoodsId:(NSString *)goodsId
                          withNum:(NSString *)num
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodsinoutrecord/add"
                     paragram:@{
                                @"type":type,
                                @"owner":[LoginUserUtil userTel],
                                @"dealer":[LoginUserUtil userId],
                                @"goods":goodsId,
                                @"remark":remark,
                                @"num":num
                                }
               successedBlock:success
                  failedBolck:failed];
}

- (void)queryGoodsInOutRecoedesWith:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed
{
    [self startNormalPostWith:@"/warehousegoodsinoutrecord/query"
                     paragram:@{
                                @"owner":[LoginUserUtil userTel],
                                }
               successedBlock:success
                  failedBolck:failed];
}


@end
