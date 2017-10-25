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
#import "WareHouseGoods.h"
#import "WarehousePurchaseInfo.h"


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
                 withShopName:(NSString *)shopName
                  withAddress:(NSString *)address
                  withChannel:(NSString *)channel
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

///重置密码
- (void)regetPwd:(NSString *)tel
         withPwd:(NSString *)pwd
  successedBlock:(SuccessedBlock)success
     failedBolck:(FailedBlock)failed;

///更新头像
- (void)updateHead:(NSString *)headUrl
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

///更新姓名
- (void)updateUserName:(NSString *)userName
              shopName:(NSString *)shopName
               address:(NSString *)address
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

///更新客户
- (void)updateCustomUrl:(ADTContacterInfo *)newContact
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

///获取某个客户的所有记录
- (void)queryOneAllRepair:(NSString *)carcode
            withContactId:(NSString *)contactId
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;

/**
 获取当前账单
 
 @param success
 @param failed
 */
- (void)queryTodayBills:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)queryAllTipedRepair:(NSString *)owner
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)clearOwnMoney:(NSString *)_id
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)uploadBOSFile:(NSString *)path
         withFileName:(NSString *)fileName
    successedBlock:(SuccessedBlock)success
       failedBolck:(FailedBlock)failed;

#pragma mark - 收费记录

- (void)addRepairItem:(ADTRepairItemInfo *)info
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)addRepairItem2:(ADTRepairItemInfo *)info
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)deleteRepairItem:(ADTRepairItemInfo *)info
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

- (void)deleteRepairItems:(NSString *)repId
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;

- (void)deleteContactItems:(NSString *)contactId
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)queryAllRepairItem:(NSString *)repId
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;

- (void)addRepairItems:(NSArray *)arrItems
        successedBlock:(SuccessedBlock)success
           failedBolck:(FailedBlock)failed;
#pragma mark - 3.2
- (void)getAllRepairsWithState:(NSString *)state
                      withPage:(NSInteger )page
                      withSize:(NSInteger )size
                     contactid:(NSString *)contactid
                       carCode:(NSString *)carCode
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;
///增加
- (void)addNewRepair4:(ADTRepairInfo *)newRep
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

///更新
- (void)updateOneRepair4:(ADTRepairInfo *)newRep
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

- (void)cancelRepair3:(NSString *)_id
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)revertRepair3:(NSString *)_id
       successedBlock:(SuccessedBlock)success
          failedBolck:(FailedBlock)failed;

- (void)updateRepairState3:(NSString *)state
                    withId:(NSString *)_id
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;


- (void)deleteOnesRepairs3:(NSString *)carcode
             withContactId:(NSString *)contactid
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)queryOnesRepairs3:(NSString *)carcode
            withContactId:(NSString *)contactid
           successedBlock:(SuccessedBlock)success
              failedBolck:(FailedBlock)failed;


- (void)queryAllTipedRepairs3:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;


- (void)queryCustomerOrders:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)updateCustomerOrderWith:(NSString *)shopName
                     withOpenId:(NSString *)openId
                         withId:(NSString *)_id
                withConfirmTime:(NSString *)confirmTime
                  withOrderTime:(NSString *)orderTime
                  withOrderInfo:(NSString *)info
                      withState:(NSString *)state
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;

- (void)delCustomerOrder:(NSString *)_id
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

#pragma mark - 3.5
#pragma mark - 库房管理

- (void)getAllWareHouseList:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)addNewWarehouseWith:(NSString *)name
                 withRemark:(NSString *)remark
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)delOneWarehouseWith:(NSString *)_id
             successedBlock:(SuccessedBlock)success
                failedBolck:(FailedBlock)failed;

- (void)updateOneWarehouseWith:(NSString *)name
                    withRemark:(NSString *)remark
                        withId:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;
#pragma mark - 库位管理
- (void)getAllWareHousePositionList:(NSString *)warehouseId
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)addNewWarehousePositionWith:(NSString *)name
                         withRemark:(NSString *)remark
                    withWarehouseId:(NSString *)warehouseId
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)delOneWarehousePositionWith:(NSString *)_id
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)updateOneWarehousePositionWith:(NSString *)name
                            withRemark:(NSString *)remark
                                withId:(NSString *)_id
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed;

#pragma mark - 供应商管理

- (void)getAllSupplierList:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;


- (void)addNewWarehouseSupplierWith:(NSString *)company
                           withName:(NSString *)name
                            withTel:(NSString *)tel
                        withAddress:(NSString *)address
                         withRemark:(NSString *)remark
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)delOneWarehouseSupplierWith:(NSString *)_id
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)updateOneWarehouseSupplierWith:(NSString *)company
                              withName:(NSString *)name
                               withTel:(NSString *)tel
                           withAddress:(NSString *)address
                            withRemark:(NSString *)remark
                                withId:(NSString *)_id
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed;


#pragma mark - 商品分类(一级分类)
- (void)getAllGoodsTypePreviewList:(SuccessedBlock)success
                       failedBolck:(FailedBlock)failed;

- (void)getAllGoodsTopTypeList:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)addNewGoodsTopTypeWith:(NSString *)name
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)delOneGoodsTopTypeWith:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)updateOneGoodsTopTypeWith:(NSString *)name
                           withId:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

#pragma mark - 商品分类(二级分类)

- (void)getAllGoodsSubTypeList:(NSString *)toptypeid
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)addNewGoodsSubTypeWith:(NSString *)name
                     withTopId:(NSString *)topId
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)addNewGoodsTopTypeRefWith:(NSArray *)subId
                        withTopId:(NSString *)topId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)delOneGoodsSubTypeWith:(NSString *)_id
                successedBlock:(SuccessedBlock)success
                   failedBolck:(FailedBlock)failed;

- (void)updateOneGoodsSubTypeWith:(NSString *)name
                           withId:(NSString *)_id
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

#pragma mark - 商品

- (void)getAllGoodsList:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)getAllGoodsListWithType:(NSString *)subtype
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;

- (void)getGoodsInfo:(NSString *)goodsId
      successedBlock:(SuccessedBlock)success
         failedBolck:(FailedBlock)failed;

- (void)addNewGoodsWith:(WareHouseGoods *)newGoods
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

- (void)updateOneGoodsWith:(WareHouseGoods *)newGoods
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;


/**
 商品入库,只需要更新个别字段即可

 @param newGoods
 @param success
 @param failed
 */
- (void)saveBuyedOneGoodsWith:(WareHouseGoods *)newGoods
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)updateOneGoodsPurchaseInfoWith:(WareHouseGoods *)newGoods
                        successedBlock:(SuccessedBlock)success
                           failedBolck:(FailedBlock)failed;

- (void)updateOneGoodsForRejectWith:(WareHouseGoods *)newGoods
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)updateOneGoodsStoreNumWith:(ADTRepairItemInfo *)item
                         withIsOut:(BOOL)isOut
                    successedBlock:(SuccessedBlock)success
                       failedBolck:(FailedBlock)failed;

- (void)delOneGoodsWith:(NSString *)_id
         successedBlock:(SuccessedBlock)success
            failedBolck:(FailedBlock)failed;

#pragma mark - 库存总览

- (void)getAllWarmingGoodsStoreList:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)getAllGoodsStoreList:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed;

- (void)addNewGoodsStoreWith:(WareHouseGoods *)goods
                    supplier:(NSString *)supplier
                         num:(NSString *)num
           warehouseposition:(NSString *)warehouseposition
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed;

- (void)delOneGoodsStoreWith:(WareHouseGoods *)goods
              successedBlock:(SuccessedBlock)success
                 failedBolck:(FailedBlock)failed;

#pragma mark - 采购
- (void)addNewPurchaseWith:(WarehousePurchaseInfo *)purchase
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)updateOnePurchaseWith:(WarehousePurchaseInfo *)purchase
               successedBlock:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)queryPurchaseGoods:(NSString *)state
            successedBlock:(SuccessedBlock)success
               failedBolck:(FailedBlock)failed;

- (void)queryAllPurchaseGoods:(SuccessedBlock)success
                  failedBolck:(FailedBlock)failed;

- (void)queryOnePurchaseGoodsInfo:(NSString *)goodsId
                   successedBlock:(SuccessedBlock)success
                      failedBolck:(FailedBlock)failed;

- (void)savePurchaseGoodsToStore:(WarehousePurchaseInfo *)purchase
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)rejectPurchaseGoodsToStore:(WarehousePurchaseInfo *)purchase
                    successedBlock:(SuccessedBlock)success
                       failedBolck:(FailedBlock)failed;


#pragma mark - 服务管理(一级分类)

- (void)getAllServiceTypePreviewList:(SuccessedBlock)success
                         failedBolck:(FailedBlock)failed;

- (void)getAllServiceTopTypeList:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)addNewServiceTopTypeWith:(NSString *)name
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)addNewServiceTopTypeRefWith:(NSArray *)subId
                          withTopId:(NSString *)topId
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;


- (void)delOneServiceTopTypeWith:(NSString *)_id
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)updateOneServiceTopTypeWith:(NSString *)name
                             withId:(NSString *)_id
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

#pragma mark - 商品分类(二级分类)

- (void)getAllServiceSubTypeList:(NSString *)toptypeid
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)addNewServiceSubTypeWith:(NSString *)name
                       withPrice:(NSString *)price
                       withTopId:(NSString *)topId
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)delOneServiceSubTypeWith:(NSString *)_id
                  successedBlock:(SuccessedBlock)success
                     failedBolck:(FailedBlock)failed;

- (void)updateOneServiceSubTypeWith:(NSString *)name
                          withPrice:(NSString *)price
                             withId:(NSString *)_id
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

#pragma mark - 出入库记录
- (void)addNewGoodsInOutRecoedeWith:(NSString *)type
                          withRemak:(NSString *)remark
                        withGoodsId:(NSString *)goodsId
                            withNum:(NSString *)num
                     successedBlock:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

- (void)queryGoodsInOutRecoedesWith:(SuccessedBlock)success
                        failedBolck:(FailedBlock)failed;

#pragma mark - 3.4.1
///更新添加收费项目设置
- (void)updateAddItemSet:(NSString *)type
          successedBlock:(SuccessedBlock)success
             failedBolck:(FailedBlock)failed;

#pragma mark - 3.4.3
- (void)getAllRepairsWithState2:(NSString *)state
                     withLastId:(NSString *)lastId
                       withSize:(NSInteger )size
                      contactid:(NSString *)contactid
                        carCode:(NSString *)carCode
                 successedBlock:(SuccessedBlock)success
                    failedBolck:(FailedBlock)failed;
@end
