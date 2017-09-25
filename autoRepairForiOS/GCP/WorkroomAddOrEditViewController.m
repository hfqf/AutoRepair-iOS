
//
//  WorkroomAddOrEditViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/7/25.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#define INDEX_0_CELL_HIGH  50
#define INDEX_1_CELL_HIGH  50
#define INPUT_ITEM_HIGH    50
#define HIGH_BOTTOM        90

#import "WorkroomAddOrEditViewController.h"
#import "WarehouseSelectGoodsToRepairViewController.h"
#import "ServiceManagerViewController.h"
#import "SBJson4.h"
@interface WorkroomAddOrEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,UIScrollViewDelegate,WarehouseSelectGoodsToRepairViewControllerDelegate,WarehouseGoodsSettingViewControllerDelegate>
{
    UIView *m_tipView;
    
    UIButton *m_bottomLeftBtn;
    UIButton *m_bottomRightBtn;
    UILabel  *m_totalLab;
    
    UITextField *m_payPrice;;
    UITextField *m_payNum;
    UITextField *m_payDesc;
    
    UITextField *m_currentTextFiled;
    UITextView *m_currentTextView;
}

@property (nonatomic,strong) NSArray *m_arrCategory;

@property (nonatomic,strong) NSArray *m_arrBtn;

@property(nonatomic,strong) ADTRepairInfo *m_rep;
@property(assign)NSInteger m_currentIndex;

@property (nonatomic,strong)ADTRepairItemInfo *m_delItem;
@end

@implementation WorkroomAddOrEditViewController

-(id)initWith:(ADTRepairInfo *)rep
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.m_rep = rep;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        [self createButtons];
        if(![self.m_rep.m_state isEqualToString:@"2"]){
            [self createBottomView];
        }
        self.tableView.delegate = self;
        [self.tableView setFrame:CGRectMake(0, 64+40, MAIN_WIDTH, MAIN_HEIGHT-64-40- ([self.m_rep.m_state isEqualToString:@"2"] ?0:HIGH_BOTTOM))];
        [self requestData:YES];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
        //注册键盘消失通知；
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo =[aNotification userInfo];
    NSValue*aValue =[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[aValue CGRectValue];
    int height =keyboardRect.size.height;

    [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width, MAIN_HEIGHT-height-self.tableView.frame.origin.y)];
}

- (void)keyboardDidHide:(NSNotification*)aNotification

{
    [self.tableView setFrame:CGRectMake(0, 64+40, MAIN_WIDTH, MAIN_HEIGHT-64-40- ([self.m_rep.m_state isEqualToString:@"2"] ?0:HIGH_BOTTOM))];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"工单处理"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-HEIGHT_NAVIGATION, DISTANCE_TOP,HEIGHT_NAVIGATION, HEIGHT_NAVIGATION)];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
//    [addBtn setTitle:@"更多" forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
    
    [backBtn removeTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(checkIsNoneInput) forControlEvents:UIControlEventTouchUpInside];
}


- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"车辆详情",@"收费项目"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH/self.m_arrCategory.count, 40)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+36, MAIN_WIDTH/self.m_arrCategory.count, 2)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
}

- (void)createBottomView
{
    UIView *m_bg = [[UIView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-HIGH_BOTTOM, MAIN_WIDTH, HIGH_BOTTOM)];
    [m_bg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:m_bg];
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    [m_bg addSubview:sep];
    
    m_totalLab = [[UILabel alloc]initWithFrame:CGRectMake(10,0.5, MAIN_WIDTH-20, 40)];
    [m_totalLab setTextAlignment:NSTextAlignmentRight];
    [m_totalLab setFont:[UIFont systemFontOfSize:20]];
    [m_totalLab setTextColor:KEY_COMMON_BLUE_CORLOR];
    [m_bg addSubview:m_totalLab];
    
    m_bottomLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_bottomLeftBtn.tag = 0;
    [m_bottomLeftBtn setFrame:CGRectMake(0, 40, MAIN_WIDTH/2, 50)];
    [m_bottomLeftBtn setBackgroundColor:KEY_COMMON_LIGHT_BLUE_CORLOR];
    [m_bottomLeftBtn setTitle:@"提交结账" forState:UIControlStateNormal];
    [m_bottomLeftBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [m_bottomLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_bottomLeftBtn addTarget:self action:@selector(bottomLeftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [m_bg addSubview:m_bottomLeftBtn];
    
    if([self.m_rep.m_state isEqualToString:@"0"]){
        [m_bottomLeftBtn setTitle:@"提交结账" forState:UIControlStateNormal];
        [m_bottomLeftBtn setBackgroundColor:KEY_COMMON_LIGHT_BLUE_CORLOR];
    }else if ([self.m_rep.m_state isEqualToString:@"1"]){
        [m_bottomLeftBtn setTitle:@"确认收款" forState:UIControlStateNormal];
        [m_bottomLeftBtn setBackgroundColor:KEY_COMMON_RED_CORLOR];
    }else if ([self.m_rep.m_state isEqualToString:@"2"]){
        m_bg.hidden = YES;
    }else if ([self.m_rep.m_state isEqualToString:@"3"]){
        [m_bottomLeftBtn setTitle:@"恢复工单" forState:UIControlStateNormal];
        [m_bottomLeftBtn setBackgroundColor:KEY_COMMON_GREEN_CORLOR];
    }
    
    m_bottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_bottomRightBtn.tag = 1;
    [m_bottomRightBtn setFrame:CGRectMake(MAIN_WIDTH/2, 40, MAIN_WIDTH/2, 50)];
    [m_bottomRightBtn setBackgroundColor:KEY_COMMON_BLUE_CORLOR];
    [m_bottomRightBtn setTitle:@"保存编辑" forState:UIControlStateNormal];
    [m_bottomRightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [m_bottomRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_bottomRightBtn addTarget:self action:@selector(bottomRightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [m_bg addSubview:m_bottomRightBtn];
    
}

#pragma mark - private

- (void)isWaitingInShopSwitcher:(UISwitch *)ch
{
    self.m_rep.m_iswatiinginshop = ch.on ? @"1" : @"0";
}

- (void)isClosePushSwitcher:(UISwitch *)ch
{
    self.m_rep.m_isClose = ch.on ? YES : NO;
}

- (void)bottomLeftBtnClicked
{
    if(self.m_rep.m_entershoptime.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"进店时间未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_km.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"进店里程未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_wantedcompletedtime.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"预计提车时间未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_repairType.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"维修内容未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_repairCircle.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"提醒周期未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_repairCircle.integerValue == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"提醒周期必须大于0" inSuperView:self.view withDuration:1];
        return;
    }
    
    
    if([self.m_rep.m_state isEqualToString:@"0"]){
        self.m_rep.m_state = @"1";
        [self updateRepair];
    }else if([self.m_rep.m_state isEqualToString:@"1"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请检查各项数据,确认收款后只能删除,无法撤销或修改,确认提交?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 10000;
        [alert show];
    }else if([self.m_rep.m_state isEqualToString:@"2"]){
        
    }else if([self.m_rep.m_state isEqualToString:@"3"]){
        self.m_rep.m_state = @"0";
        [self updateRepair];
    }else{
        
    }
    
    
}

- (void)bottomRightBtnClicked
{
    if(self.m_rep.m_entershoptime.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"进店时间未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_km.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"进店里程未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_wantedcompletedtime.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"预计提车时间未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_repairType.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"维修内容未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_repairCircle.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"提醒周期未填" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_rep.m_repairCircle.integerValue == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"提醒周期必须大于0" inSuperView:self.view withDuration:1];
        return;
    }

    [self addNewItesms];
}


- (void)addNewItesms
{

    [self showWaitingView];
    [HTTP_MANAGER deleteRepairItems:self.m_rep.m_contactid
                     successedBlock:^(NSDictionary *succeedResult) {

                         NSMutableArray *arr = [NSMutableArray array];
                         for(ADTRepairItemInfo *itemInfo in self.m_rep.m_arrRepairItem){
                             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                             [dic setObject:itemInfo.m_repid == nil ? @"" : itemInfo.m_repid forKey:@"repid"];
                             [dic setObject:itemInfo.m_contactid == nil ? @"" :itemInfo.m_contactid forKey:@"contactid"];
                             [dic setObject:itemInfo.m_type forKey:@"name"];
                             [dic setObject:itemInfo.m_price forKey:@"price"];
                             [dic setObject:itemInfo.m_num forKey:@"num"];
                             [dic setObject:itemInfo.m_type forKey:@"type"];
                             [dic setObject:itemInfo.m_itemType == nil ? @"0" : itemInfo.m_itemType forKey:@"itemtype"];
                             [dic setObject:itemInfo.m_goodsId == nil ? @"" :itemInfo.m_goodsId forKey:@"goods"];
                             [dic setObject:itemInfo.m_serviceId == nil ? @"" :itemInfo.m_serviceId forKey:@"service"];
                             [arr addObject:dic];
                         }

                         [HTTP_MANAGER addRepairItems:arr
                                       successedBlock:^(NSDictionary *succeedResult) {
                                           [self removeWaitingView];
                                           if([succeedResult[@"code"]integerValue] == 1){

                                               NSArray *arrRet =succeedResult[@"ret"];
                                               for(NSDictionary *cell in arrRet){
                                                   for(ADTRepairItemInfo *item in self.m_rep.m_arrRepairItem){
                                                       if([item.m_goodsId isEqualToString:cell[@"goods"]] || [item.m_serviceId isEqualToString:cell[@"service"]]){
                                                           item.m_id = cell[@"_id"];
                                                       }
                                                   }
                                               }

                                               [self updateRepair];

                                           }else{
                                               [PubllicMaskViewHelper showTipViewWith:@"保存编辑失败" inSuperView:self.view withDuration:1];
                                           }

                                       } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                           [self removeWaitingView];
                                           [PubllicMaskViewHelper showTipViewWith:@"保存编辑失败" inSuperView:self.view withDuration:1];
                                       }];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

    }];



}
- (void)updateRepair
{

    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df1 setLocale:locale];
    NSDate *date=[df1 dateFromString:self.m_rep.m_wantedcompletedtime];
    
    NSDate *dateToDay = [NSDate dateWithTimeInterval:[self.m_rep.m_repairCircle integerValue]*24*3600 sinceDate:date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    self.m_rep.m_targetDate = strDate;
    
    [self showWaitingView];
    [HTTP_MANAGER updateOneRepair4:self.m_rep
                   successedBlock:^(NSDictionary *succeedResult) {
                       
                       [self removeWaitingView];
                       if([succeedResult[@"code"]integerValue] == 1)
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_UPDATED object:nil];
                           [PubllicMaskViewHelper showTipViewWith:@"更新成功" inSuperView:self.view withDuration:1];
                           [self requestData:YES];
                       }
                       else
                       {
                           [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view withDuration:1];
                           
                       }
                       
                       
                       
                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view withDuration:1];
                   }];
    
    
}

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestData:YES];
    
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == btn.tag)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(self.m_currentIndex*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}


- (void)addBtnClicked
{
    if([self.m_rep.m_state isEqualToString:@"0"]){
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"取消此工单",@"删除此工单", nil];
        alert.tag = 10002;
        [alert show];
    }else if ([self.m_rep.m_state isEqualToString:@"1"]){
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"取消此工单",@"删除此工单", nil];
        alert.tag = 10002;
        [alert show];
    }else if ([self.m_rep.m_state isEqualToString:@"2"]){
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除此工单",@"关闭提醒推送",@"打开提醒推送", nil];
        alert.tag = 10003;
        [alert show];
    }else{
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"恢复此工单",@"删除此工单", nil];
        alert.tag = 10004;
        [alert show];
    }
}


- (void)checkIsNoneInput
{
    if(self.m_rep.m_entershoptime.length == 0||
       self.m_rep.m_km.length == 0||
       self.m_rep.m_wantedcompletedtime.length == 0||
       self.m_rep.m_repairType.length == 0||
       self.m_rep.m_repairCircle.length == 0){
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"当前工单未编辑完成,确认返回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 10001;
        [alert show];
    }else{
        if([self.m_rep.m_state isEqualToString:@"2"]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self autoUpdateAndFinish];
        }
    }
}

- (void)autoUpdateAndFinish
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df1 setLocale:locale];
    NSDate *date=[df1 dateFromString:self.m_rep.m_wantedcompletedtime];
    
    NSDate *dateToDay = [NSDate dateWithTimeInterval:[self.m_rep.m_repairCircle integerValue]*24*3600 sinceDate:date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    self.m_rep.m_targetDate = strDate;
    
    [self showWaitingView];
    [HTTP_MANAGER updateOneRepair4:self.m_rep
                    successedBlock:^(NSDictionary *succeedResult) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_UPDATED object:nil];
                        [self removeWaitingView];
                        [self.navigationController popViewControllerAnimated:YES];

                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                        [self removeWaitingView];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self.m_rep updateTotalPrice];
    [self reloadDeals];
    [m_totalLab setText:[NSString stringWithFormat:@"总计:¥ %lu",(long)self.m_rep.m_totalPrice]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 0){
        return INDEX_0_CELL_HIGH;
    }else{
        return INDEX_1_CELL_HIGH;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.m_currentIndex == 0){
        return 4;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.m_currentIndex == 0){
        if(section == 0){
            return 6;
        }else if (section == 1){
            return 5;
        }else if (section == 2){
            return 2;
        }else if (section == 3){
            return 2;
        }
    }else{
        return self.m_rep.m_arrRepairItem.count;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.m_currentIndex == 0){
        return INDEX_0_CELL_HIGH;
    }else{
        return [self.m_rep.m_state isEqualToString:@"2"] ? 0 : INPUT_ITEM_HIGH;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.m_currentIndex == 0){
        return 10;
    }else{
        return 0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.m_currentIndex == 0){
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, INDEX_0_CELL_HIGH)];
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MAIN_WIDTH, INDEX_0_CELL_HIGH-20-0.5)];
        [tip setBackgroundColor:[UIColor clearColor]];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont systemFontOfSize:18]];
        [vi addSubview:tip];
        if(section == 0){
            [tip setText:@"车辆信息"];
        }else if(section == 1){
            [tip setText:@"接车事项"];
        }else if(section == 2){
            [tip setText:@"检车问题"];
        }else if(section == 3){
            [tip setText:@"提醒事项"];
        }else{
            
        }
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,INDEX_0_CELL_HIGH-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        [vi addSubview:sep];
        return vi;
    }else{
        if([self.m_rep.m_state isEqualToString:@"2"] ){
            UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 0)];
            return vi;
        }else{
            UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, INPUT_ITEM_HIGH)];
            
//            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,(INPUT_ITEM_HIGH-40)/2, 100, 40)];
//            tip.numberOfLines = 0;
//            [tip setBackgroundColor:[UIColor clearColor]];
//            [tip setTextColor:[UIColor blackColor]];
//            [tip setFont:[UIFont systemFontOfSize:15]];
//            [tip setText:@"增加收费明细:"];
//            [vi addSubview:tip];
//
//            m_payDesc =[[UITextField alloc]initWithFrame:CGRectMake(120,10, MAIN_WIDTH-130, 30)];
//            m_payDesc.tag = 1000;
//            [m_payDesc setFont:[UIFont systemFontOfSize:14]];
//            m_payDesc.layer.cornerRadius = 3;
//            m_payDesc.layer.borderColor = KEY_COMMON_GRAY_CORLOR.CGColor;
//            m_payDesc.layer.borderWidth = 0.2;
//            m_payDesc.delegate = self;
//            [m_payDesc setPlaceholder:@"请输入收费项目"];
//            [vi addSubview:m_payDesc];
//            m_payPrice =[[UITextField alloc]initWithFrame:CGRectMake(120,50, MAIN_WIDTH-130, 30)];
//            m_payPrice.tag = 1001;
//            [m_payPrice setFont:[UIFont systemFontOfSize:14]];
//            m_payPrice.layer.cornerRadius = 3;
//            m_payPrice.layer.borderColor = KEY_COMMON_GRAY_CORLOR.CGColor;
//            m_payPrice.layer.borderWidth = 0.2;
//            m_payPrice.delegate = self;
//            m_payPrice.keyboardType = UIKeyboardTypeNumberPad;
//            [m_payPrice setPlaceholder:@"请输入收费价格"];
//            [vi addSubview:m_payPrice];
//            m_payNum =[[UITextField alloc]initWithFrame:CGRectMake(120,90, MAIN_WIDTH-130, 30)];
//            m_payNum.tag = 1002;
//            [m_payNum setFont:[UIFont systemFontOfSize:14]];
//            m_payNum.layer.cornerRadius = 3;
//            m_payNum.layer.borderColor = KEY_COMMON_GRAY_CORLOR.CGColor;
//            m_payNum.layer.borderWidth = 0.2;
//            m_payNum.delegate = self;
//            m_payNum.keyboardType = UIKeyboardTypeNumberPad;
//            [m_payNum setPlaceholder:@"此条收费的次数或数量"];
//            [vi addSubview:m_payNum];
//
            UIButton *addItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addItemBtn setFrame:CGRectMake(10,10, MAIN_WIDTH/2-20, 30)];
            [addItemBtn setTitle:@"添加商品" forState:UIControlStateNormal];
            [addItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [addItemBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
            addItemBtn.backgroundColor = KEY_COMMON_BLUE_CORLOR;
            addItemBtn.layer.cornerRadius = 3;
            //        addItemBtn.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            //        addItemBtn.layer.borderWidth = 0.2;
            [vi addSubview:addItemBtn];
            [addItemBtn addTarget:self action:@selector(addGoodsItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];

            UIButton *addServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addServiceBtn setFrame:CGRectMake(10+MAIN_WIDTH/2,10, MAIN_WIDTH/2-20, 30)];
            [addServiceBtn setTitle:@"添加服务" forState:UIControlStateNormal];
            [addServiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [addServiceBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
            addServiceBtn.backgroundColor = KEY_COMMON_BLUE_CORLOR;
            addServiceBtn.layer.cornerRadius = 3;
            //        addItemBtn.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            //        addItemBtn.layer.borderWidth = 0.2;
            [vi addSubview:addServiceBtn];
            [addServiceBtn addTarget:self action:@selector(addServicesItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,INPUT_ITEM_HIGH-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
            [vi addSubview:sep];
            return vi;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 0){
        static NSString * identify = @"spe1";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, (INDEX_0_CELL_HIGH-10))];
            [tip setTextColor:KEY_COMMON_GRAY_CORLOR];
            [tip setTextAlignment:NSTextAlignmentLeft];
            tip.numberOfLines = 0;
            [tip setFont:[UIFont systemFontOfSize:14]];
            [cell addSubview:tip];
            if(indexPath.section == 0){
                UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, MAIN_WIDTH-150, (INDEX_0_CELL_HIGH-20))];
                [content setTextColor:KEY_COMMON_GRAY_CORLOR];
                [content setTextAlignment:NSTextAlignmentLeft];
                [content setFont:[UIFont systemFontOfSize:14]];
                [cell addSubview:content];
                
                ADTContacterInfo *con = [DB_Shared contactWithCarCode:self.m_rep.m_carCode withContactId:self.m_rep.m_idFromNode];
                if(indexPath.row == 0){
                    [tip setText:@"客户"];
                    [content setText:con.m_userName];
                }else if (indexPath.row == 1)
                {
                    [tip setText:@"车辆"];
                    [content setText:con.m_carCode];
                }else if (indexPath.row == 2)
                {
                    [tip setText:@"号码"];
                    [content setText:con.m_tel];
                }else if (indexPath.row == 3)
                {
                    [tip setText:@"车型"];
                    [content setText:con.m_carType];
                }else if (indexPath.row == 4)
                {
                    [tip setText:@"车架号"];
                    [content setText:con.m_strVin.length == 0?@"暂无":con.m_strVin];
                }else if (indexPath.row == 5)
                {
                    [tip setText:@"车辆注册时间"];
                    [content setText:con.m_strCarRegistertTime.length == 0 ? @"暂无":con.m_strCarRegistertTime];
                }
                
            }else if (indexPath.section == 1){
                UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, MAIN_WIDTH-150, (INDEX_0_CELL_HIGH-20))];
                input.delegate = self;
                input.font = [UIFont systemFontOfSize:14];
                input.textColor = KEY_COMMON_GRAY_CORLOR;
                input.returnKeyType = UIReturnKeyDone;
                if(indexPath.row == 0){
                    input.tag = 100;
                    [cell addSubview:input];
                    [tip setText:@"入店时间"];
                    [input setText:self.m_rep.m_entershoptime];
                }else if (indexPath.row == 1)
                {
                    input.tag = 101;
                    [cell addSubview:input];
                    [tip setText:@"入店里程(KM)"];
                    input.keyboardType = UIKeyboardTypeNumberPad;
                    [input setPlaceholder:@"必填"];
                    [input setText:self.m_rep.m_km];
                }else if (indexPath.row == 2)
                {
                    [tip setText:@"是否在店等"];
                    UISwitch *switcher1 = [[UISwitch alloc]initWithFrame:CGRectMake(140,(INDEX_0_CELL_HIGH-30)/2, 30, 30)];
                    switcher1.on = [self.m_rep.m_iswatiinginshop isEqualToString:@"1"];
                    switcher1.enabled = ![self.m_rep.m_state isEqualToString:@"2"];;
                    [switcher1 addTarget:self action:@selector(isWaitingInShopSwitcher:) forControlEvents:UIControlEventValueChanged];
                    [cell addSubview:switcher1];
                }else if (indexPath.row == 3)
                {
                    input.tag = 103;
                    [cell addSubview:input];
                    [tip setText:@"预计提车时间"];
                    [input setText:self.m_rep.m_wantedcompletedtime];
                    [input setPlaceholder:@"必填"];
                }else if (indexPath.row == 4)
                {
                    input.tag = 104;
                    [cell addSubview:input];
                    [tip setText:@"客户备注"];
                    [input setText:self.m_rep.m_customremark];
                }
            }else if (indexPath.section == 2){
                
                if(indexPath.row == 0){
                    UITextView *input = [[UITextView alloc]initWithFrame:CGRectMake(140, 0, MAIN_WIDTH-150, INDEX_0_CELL_HIGH)];
                    input.delegate = self;
                    input.font = [UIFont systemFontOfSize:14];
                    input.textColor = KEY_COMMON_GRAY_CORLOR;
                    [input setTextAlignment:NSTextAlignmentLeft];
                    [cell addSubview:input];
                    input.returnKeyType = UIReturnKeyDone;
                    [tip setText:@"维修内容"];
                    if(self.m_rep.m_repairType.length == 0){
                        [input setText:@"必填"];
                    }else{
                        [input setText:self.m_rep.m_repairType];
                    }
                }else
                {
                    UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, MAIN_WIDTH-50, (INDEX_0_CELL_HIGH-20))];
                    input.delegate = self;
                    [input setTextAlignment:NSTextAlignmentLeft];
                    input.font = [UIFont systemFontOfSize:14];
                    input.textColor = KEY_COMMON_GRAY_CORLOR;
                    [cell addSubview:input];
                    input.returnKeyType = UIReturnKeyDone;
                    input.tag = 105;
                    [tip setText:@"维修备注"];
                    [input setText:self.m_rep.m_more];
                }
            }else{
                
              
                if(indexPath.row == 0){
                    [tip setText:@"提醒周期(下次保养)"];
                    UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, MAIN_WIDTH-50, (INDEX_0_CELL_HIGH-20))];
                    input.delegate = self;
                    [input setTextAlignment:NSTextAlignmentLeft];
                    input.font = [UIFont systemFontOfSize:14];
                    input.textColor = KEY_COMMON_GRAY_CORLOR;
                    [cell addSubview:input];
                    input.keyboardType = UIKeyboardTypeNumberPad;
                    [input setText:self.m_rep.m_repairCircle];
                    input.tag = 106;
                    [input setPlaceholder:@"必填(天)"];
                }else
                {
                    [tip setText:@"是否关闭提醒"];
                    UISwitch *switcher1 = [[UISwitch alloc]initWithFrame:CGRectMake(140,(INDEX_0_CELL_HIGH-30)/2, 30, 30)];
                    switcher1.on = self.m_rep.m_isClose;
                    switcher1.enabled = ![self.m_rep.m_state isEqualToString:@"2"];;;
                    [switcher1 addTarget:self action:@selector(isClosePushSwitcher:) forControlEvents:UIControlEventValueChanged];
                    [cell addSubview:switcher1];
                }
            }
        
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,INDEX_0_CELL_HIGH-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
            [cell addSubview:sep];
        
        return cell;
    }else{
        static NSString * identify = @"spe2";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ADTRepairItemInfo*item = [self.m_rep.m_arrRepairItem objectAtIndex:indexPath.row];
        
        UILabel *repairType = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, MAIN_WIDTH-35, 20)];
        [repairType setTextAlignment:NSTextAlignmentLeft];
        [repairType setText:[NSString stringWithFormat:@"%@(%@)",item.m_type,item.m_itemType.integerValue == 0 ? @"维修" : @"保养"]];
        [repairType setTextColor:KEY_COMMON_GRAY_CORLOR];
        [cell addSubview:repairType];
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(5,30,MAIN_WIDTH/3,INDEX_1_CELL_HIGH-30)];
        [price setTextAlignment:NSTextAlignmentLeft];
        [price setFont:[UIFont systemFontOfSize:14]];
        [price setText:[NSString stringWithFormat:@"¥%@", item.m_price]];
        [price setTextColor:[UIColor blackColor]];
        [cell addSubview:price];
        
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(5+MAIN_WIDTH/3,30,MAIN_WIDTH/3,INDEX_1_CELL_HIGH-30)];
        [num setTextAlignment:NSTextAlignmentLeft];
        [num setFont:[UIFont systemFontOfSize:14]];
        [num setText:[NSString stringWithFormat:@"x%@", item.m_num]];
        [num setTextColor:[UIColor blackColor]];
        [cell addSubview:num];
        
        UILabel *totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/3*2,30,MAIN_WIDTH/3-5,INDEX_1_CELL_HIGH-30)];
        [totalPrice setTextAlignment:NSTextAlignmentRight];
        [totalPrice setFont:[UIFont systemFontOfSize:14]];
        [totalPrice setText:[NSString stringWithFormat:@"¥%lu", (long)item.m_currentPrice]];
        [totalPrice setTextColor:[UIColor blackColor]];
        [cell addSubview:totalPrice];
        
        
        if(![self.m_rep.m_state isEqualToString:@"2"]){
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.tag = indexPath.row;
            [delBtn setFrame:CGRectMake(MAIN_WIDTH-30, 0, 30, 30)];
                [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:   UIControlEventTouchUpInside];
            
            [delBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
            [cell addSubview:delBtn];
        }

        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,INDEX_1_CELL_HIGH-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        [cell addSubview:sep];
        return cell;
    }
}


- (void)cancelBtnClicked:(UITextField *)input
{
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            if(picker.tag == 0){
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (void)confirmBtnClicked:(UITextField *)input
{
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith3:[picker date]];
            if(picker.tag == 0){
                self.m_rep.m_entershoptime = time;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                self.m_rep.m_wantedcompletedtime = time;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (void)delBtnClicked:(UIButton *)btn
{
    self.m_delItem = [self.m_rep.m_arrRepairItem objectAtIndex:btn.tag];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除此收费项目?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 1;
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)addItemBtnClicked
{
    if(m_payDesc.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"收费项目不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_payPrice.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"收费价格不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_payNum.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"收费次数或数量不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    ADTRepairItemInfo *item = [[ADTRepairItemInfo alloc]init];
    item.m_repid = self.m_rep.m_idFromNode;
    item.m_contactid = self.m_rep.m_contactid;
    item.m_price = m_payPrice.text;
    item.m_num = m_payNum.text;
    item.m_type = m_payDesc.text;
    item.m_itemType = @"0";
    item.m_currentPrice =  [item.m_price integerValue]* [item.m_num integerValue];
    [m_payNum resignFirstResponder];
    
    [self showWaitingView];
    [HTTP_MANAGER addRepairItem:item
                    successedBlock:^(NSDictionary *succeedResult) {
                        [self removeWaitingView];
                        if([succeedResult[@"code"]integerValue] == 1){
                            item.m_id = succeedResult[@"ret"][@"_id"];
                            [PubllicMaskViewHelper showTipViewWith:@"添加成功" inSuperView:self.view withDuration:1];
                            [self.m_rep.m_arrRepairItem addObject:item];
                            [self updateRepair];
                        }else{
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
                        }
                        
                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                        [self removeWaitingView];
                        [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
                    }];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            [self delItem];
        }
    }else if (alertView.tag == 10000){
        if(buttonIndex == 1){
            self.m_rep.m_state = @"2";
            [self updateRepair];
        }
    }else if(alertView.tag == 10001){
        if(buttonIndex == 1){
            if(self.m_rep.m_isAddNewRepair){
                [self deleteOneRepairServerAndLocalDB];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else if (alertView.tag == 10002){
        if(buttonIndex == 1){
            [self cancelRepair];
        }
        else if (buttonIndex == 2){
            [self  deleteOneRepairServerAndLocalDB];
        }
    }else if (alertView.tag == 10003){
        if(buttonIndex == 1){
            [self deleteOneRepairServerAndLocalDB];
        }
        else if (buttonIndex == 2){
            self.m_rep.m_isClose = YES;
            self.m_rep.m_isreaded = YES;
            [self updateRepair];
        }
        else if (buttonIndex == 3){
            self.m_rep.m_isClose = NO;
            self.m_rep.m_isreaded = NO;
            [self updateRepair];
        }
    }else if (alertView.tag == 10004){
        if(buttonIndex == 1){
            [self revertRepair];
        }
        else if (buttonIndex == 2){
            [self  deleteOneRepairServerAndLocalDB];
        }else{
          
        }
    }
    
}

- (void)revertRepair
{
    [self showWaitingView];
    [HTTP_MANAGER revertRepair3:self.m_rep.m_idFromNode
                 successedBlock:^(NSDictionary *succeedResult) {
                     [self removeWaitingView];
                     if([succeedResult[@"code"] integerValue] == 1)
                     {
                         [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_UPDATED object:nil];
                         [PubllicMaskViewHelper showTipViewWith:@"取消成功" inSuperView:self.view withDuration:1];
                         [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                     }
                     else
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"取消失败" inSuperView:self.view withDuration:1];
                     }
                     
                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                     [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:@"取消失败" inSuperView:self.view withDuration:1];
                     
                 }];
}

- (void)cancelRepair
{
    [self showWaitingView];
    [HTTP_MANAGER cancelRepair3:self.m_rep.m_idFromNode
                successedBlock:^(NSDictionary *succeedResult) {
                    [self removeWaitingView];
                    if([succeedResult[@"code"] integerValue] == 1)
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_UPDATED object:nil];
                        [PubllicMaskViewHelper showTipViewWith:@"取消成功" inSuperView:self.view withDuration:1];
                        [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"取消失败" inSuperView:self.view withDuration:1];
                    }
                    
                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                    [self removeWaitingView];
                    [PubllicMaskViewHelper showTipViewWith:@"取消失败" inSuperView:self.view withDuration:1];
                    
                }];
}

- (void)deleteOneRepairServerAndLocalDB
{
    [self showWaitingView];
    [HTTP_MANAGER delOneRepair:self.m_rep
                successedBlock:^(NSDictionary *succeedResult) {
                    [self removeWaitingView];
                    if([succeedResult[@"code"] integerValue] == 1)
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_UPDATED object:nil];
                        [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];

                        
                        [HTTP_MANAGER deleteRepairItems:self.m_rep.m_carCode
                                         successedBlock:^(NSDictionary *succeedResult) {
                            
                            
                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                            
                            
                        }];
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                    }
                    
                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                    [self removeWaitingView];
                    
                }];
}

- (void)delItem
{

    if(self.m_delItem.m_id == nil){
        [self.m_rep.m_arrRepairItem removeObject:self.m_delItem];
        [self requestData:YES];
    }else{
        [HTTP_MANAGER deleteRepairItem:self.m_delItem
                        successedBlock:^(NSDictionary *succeedResult) {
                            [self removeWaitingView];
                            if([succeedResult[@"code"]integerValue] == 1){
                                [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_UPDATED object:nil];
                                [PubllicMaskViewHelper showTipViewWith:@"删除成功" inSuperView:self.view withDuration:1];
                                [self.m_rep.m_arrRepairItem removeObject:self.m_delItem];
                                [self requestData:YES];
                            }else{
                                [self removeWaitingView];
                                [PubllicMaskViewHelper showTipViewWith:@"删除失败" inSuperView:self.view withDuration:1];
                            }

                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"删除失败" inSuperView:self.view withDuration:1];
                        }];
    }


}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    m_currentTextFiled = textField;
    if(textField.tag == 100){
        UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
        [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:cancelBtn];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
        [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:confirmBtn];
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH-100, 140)];
        picker.tag = 0;
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        [inputBg addSubview:picker];
        textField.inputView = inputBg;
        return YES;
    }else  if(textField.tag == 103){
        UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
        [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:cancelBtn];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
        [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [inputBg addSubview:confirmBtn];
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH-100, 140)];
        picker.tag = 1;
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        [inputBg addSubview:picker];
        textField.inputView = inputBg;
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 100){
        
    }else if (textField.tag == 101){
        self.m_rep.m_km = textField.text;
    }else if (textField.tag == 102){
        
    }else if (textField.tag == 103){
        
    }else if (textField.tag == 104){
        self.m_rep.m_customremark = textField.text;
    }else if (textField.tag == 105){
        self.m_rep.m_more = textField.text;
    }else if (textField.tag == 106){
        self.m_rep.m_repairCircle = textField.text;
    }else if (textField.tag == 107){
        
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 100){
        
    }else if (textField.tag == 101){
        self.m_rep.m_km = textField.text;
    }else if (textField.tag == 102){
        
    }else if (textField.tag == 103){
        
    }else if (textField.tag == 104){
        self.m_rep.m_customremark = textField.text;
    }else if (textField.tag == 105){
        self.m_rep.m_more = textField.text;
    }else if (textField.tag == 106){
        self.m_rep.m_repairCircle = textField.text;
    }else if (textField.tag == 107){
        
    }
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"必填"]){
        [textView setText:@""];
    }
    m_currentTextView = textView;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.m_rep.m_repairType = textView.text;
    return  YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [m_currentTextView resignFirstResponder];
    [m_currentTextFiled resignFirstResponder];
}

#pragma mark - 添加服务或维修项目

- (void)addGoodsItemBtnClicked
{
    NSMutableDictionary *selectedNum = [NSMutableDictionary dictionary];
    for(ADTRepairItemInfo *item in self.m_rep.m_arrRepairItem){
        if(item.m_itemType.integerValue == 0 && item.m_num.integerValue >0){
            [selectedNum setObject:item.m_num forKey:[NSString stringWithFormat:@"0_%@",item.m_type]];
        }
    }
    WarehouseSelectGoodsToRepairViewController * select = [[WarehouseSelectGoodsToRepairViewController alloc]initWithSelected:selectedNum];
    select.m_selectDelegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

- (void)addServicesItemBtnClicked
{
    NSMutableDictionary *selectedNum = [NSMutableDictionary dictionary];
    for(ADTRepairItemInfo *item in self.m_rep.m_arrRepairItem){
        if(item.m_itemType.integerValue == 1 && item.m_num.integerValue >0){
            [selectedNum setObject:item.m_num forKey:[NSString stringWithFormat:@"1_%@",item.m_type]];
        }
    }
    ServiceManagerViewController *select = [[ServiceManagerViewController alloc]initForSelectType:selectedNum];
    select.m_selectDelegate = self;
    [self.navigationController pushViewController:select animated:YES];
}

#pragma mark - WarehouseSelectGoodsToRepairViewControllerDelegate
- (void)onWarehouseSelectGoodsToRepairViewControllerSelected:(NSArray *)arrGoods
{
    NSMutableArray *arr= [NSMutableArray array];
    for(WareHouseGoods *good in arrGoods){
        if(good.m_selectedNum.integerValue > 0){
            ADTRepairItemInfo *item = [[ADTRepairItemInfo alloc]init];
            item.m_repid = self.m_rep.m_idFromNode;
            item.m_contactid = self.m_rep.m_contactid;
            item.m_price = good.m_costprice;
            item.m_num = good.m_selectedNum;
            item.m_type = good.m_name;
            item.m_itemType = @"0";
            item.m_goodsId = good.m_id;
            item.m_currentPrice =  [item.m_price integerValue]* [item.m_num integerValue];
            [arr addObject:item];
        }
    }

    for(ADTRepairItemInfo *item in self.m_rep.m_arrRepairItem){
        if(item.m_itemType.integerValue == 1){
            [arr addObject:item];
        }
    }

    self.m_rep.m_arrRepairItem = arr;
    [self  requestData:YES];
}

#pragma mark - WarehouseGoodsSettingViewControllerDelegate
- (void)onSelectedServices:(NSArray *)arrServices
{
    NSMutableArray *arr= [NSMutableArray array];
    for(ADTRepairItemInfo *item in self.m_rep.m_arrRepairItem){
        if(item.m_itemType.integerValue == 0){
            [arr addObject:item];
        }
    }

    for(WarehouseTopTypeInfo *top in arrServices){
        for(WarehouseSubTypeInfo *sub in top.m_arrTypes){
            if(sub.m_selectedNum.integerValue > 0){
                ADTRepairItemInfo *item = [[ADTRepairItemInfo alloc]init];
                item.m_repid = self.m_rep.m_idFromNode;
                item.m_contactid = self.m_rep.m_contactid;
                item.m_price = sub.m_price;
                item.m_num = sub.m_selectedNum;
                item.m_type = sub.m_name;
                item.m_itemType = @"1";
                item.m_serviceId = sub.m_id;
                item.m_currentPrice =  [item.m_price integerValue]* [item.m_num integerValue];
                [arr addObject:item];
            }
        }
    }

    self.m_rep.m_arrRepairItem = arr;
    [self  requestData:YES];

}


@end
