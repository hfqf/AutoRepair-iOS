//
//  LlxViewController.m
//  shaobao
//
//  Created by points on 2017/9/16.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "LlxViewController.h"
#import "ADTLxxItemInfo.h"
#import "AddNewLxxViewController.h"
#import "LxxTableViewCell.h"
#import "MWPhotoBrowser.h"
@interface LlxViewController ()<UITableViewDataSource,UITableViewDelegate,LxxTableViewCellDelegate,UITextFieldDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate>
{
       UIView *m_tipView;
}
@property(nonatomic,strong)ADTLxxItemInfo *m_commentInfo;
@property(nonatomic,strong)UITextField *m_input;
@property(nonatomic,strong) NSMutableArray *m_arrPhoto;

@end

@implementation LlxViewController
-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        self.m_input = [[UITextField alloc]initWithFrame:CGRectMake(0,MAIN_HEIGHT, MAIN_WIDTH, 44)];
        self.m_input.layer.borderColor = KEY_COMMON_CORLOR.CGColor;
        self.m_input.layer.borderWidth = 0.5;
        [self.m_input setClearButtonMode:UITextFieldViewModeAlways];
        [self.m_input setBackgroundColor:[UIColor whiteColor]];
        [self.m_input setPlaceholder:@"请输入评论"];
        [self.m_input setTextColor:[UIColor blackColor]];
        self.m_input.delegate = self;
        self.m_input.returnKeyType = UIReturnKeyDone;
        [self.view addSubview:self.m_input];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

//        [self createButtons];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"汽修圈"];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(MAIN_WIDTH-80,20, 70, 44)];
    [slideBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [slideBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
}

- (void)addBtnClicked
{
    AddNewLxxViewController *add = [[AddNewLxxViewController alloc]init];
    add.m_delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}

- (void)onRefreshParentData
{
    [self requestData:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"最新议题",@"最热话题"];

    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame)-10, MAIN_WIDTH/self.m_arrCategory.count, 36)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+32, MAIN_WIDTH/self.m_arrCategory.count, 4)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
    [self.tableView setFrame:CGRectMake(0,104, MAIN_WIDTH,MAIN_HEIGHT-104-HEIGHT_MAIN_BOTTOM)];
}

#pragma mark - private

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestCategoryData];

}


- (void)requestCategoryData
{
    [self requestData:YES];
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == self.m_currentIndex)
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

- (void)requestData:(BOOL)isRefresh
{
    NSString *lastTime= nil;
    if(isRefresh){
        lastTime = [LocalTimeUtil getCurrentTime];
    }else{
        if(self.m_arrData.count>0){
            ADTLxxItemInfo *rep = [self.m_arrData lastObject];
            lastTime = rep.m_createTime;
        }else{
            lastTime = [LocalTimeUtil getCurrentTime];
        }
    }
    [self showWaitingView];
    [HTTP_MANAGER queryBBSList:lastTime
                successedBlock:^(NSDictionary *succeedResult) {
                    [self removeWaitingView];
                    if([succeedResult[@"code"]integerValue] == 1){
                        NSArray *arr = succeedResult[@"ret"];
                        NSMutableArray *arrInsert = isRefresh ?  [NSMutableArray array] : [NSMutableArray arrayWithArray:self.m_arrData];
                        for(NSDictionary *info in arr){
                            ADTLxxItemInfo *_info = [ADTLxxItemInfo from:info];
                            [arrInsert addObject:_info];
                        }
                        self.m_arrData = arrInsert;
                    }
                    [self reloadDeals];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self reloadDeals];
    }];
}

- (CGFloat)high:(ADTLxxItemInfo *)currentData
{
    CGFloat high = 40;
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:[UIFont systemFontOfSize:15] withWidth:(MAIN_WIDTH-(20+70))];
    high+=size.height;
    high+=40;

    NSInteger row = ceil(currentData.m_arrPics.count/3.0);
    NSInteger sep = 10;
    NSInteger cell_num = 3;
    NSInteger width = (MAIN_WIDTH-(70+sep*(cell_num+1)))/3;
    high+= (sep+width)*row;


    for(NSDictionary *info in currentData.m_arrComments){
        NSString *content = [NSString stringWithFormat:@"%@回复:%@",info[@"userName"], info[@"content"]];
        CGSize size = [FontSizeUtil sizeOfString:content withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-130];
        high += (size.height > 40 ? size.height : 40);
    }
    return high;
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:[self.m_arrData objectAtIndex:indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    LxxTableViewCell *cell = [[LxxTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.m_delegate = self;
    cell.currentData = [self.m_arrData objectAtIndex:indexPath.row];
    return cell;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-kbSize.height-44)];
    self.m_input.frame = CGRectMake(0, MAIN_HEIGHT-44-kbSize.height, MAIN_WIDTH, 44);
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, MAIN_WIDTH,MAIN_HEIGHT-self.tableView.frame.origin.y-HEIGHT_MAIN_BOTTOM)];
    self.m_input.frame = CGRectMake(0, MAIN_HEIGHT, MAIN_WIDTH, 44);
}

#pragma mark - LxxTableViewCellDelegate

- (void)onLxxTableViewCellDelegateForDel:(ADTLxxItemInfo *)info
{
    self.m_commentInfo = info;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法恢复,确认删除?" message:nil
delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        [HTTP_MANAGER delBBS:self.m_commentInfo.m_id
              successedBlock:^(NSDictionary *succeedResult) {
                  if([succeedResult[@"code"]integerValue]==1){
                      [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                      [self requestData:YES];
                  }else{
                      [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                  }
              } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

              }];
    }
}
- (void)onLxxTableViewCellDelegateForComment:(ADTLxxItemInfo *)info
{
    self.m_commentInfo = info;
    [self.m_input becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self showWaitingView];
    [HTTP_MANAGER addNewBBSComment:[LoginUserUtil userTel]
                        sendername:[LoginUserUtil userName]
                            avatar:[LoginUserUtil headUrl]
                           content:textField.text
                             bbsId:self.m_commentInfo.m_id
                    successedBlock:^(NSDictionary *succeedResult) {
                        if([succeedResult[@"code"]integerValue]==1){
                            [self.m_commentInfo.m_arrRefs addObject:succeedResult[@"ret"][@"_id"]];
                            [HTTP_MANAGER updateBBSRefs:self.m_commentInfo.m_id
                                                    ref:self.m_commentInfo.m_arrRefs
                                         successedBlock:^(NSDictionary *succeedResult) {
                                             [self removeWaitingView];
                                                        [self requestData:YES];
                                                        [self.m_input setText:nil];

                            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                [self removeWaitingView];
                            }];

                        }

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
    }];

    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl
{

    NSMutableArray *arr = [NSMutableArray array];
    for(NSString *url in arrUrl){
        if(url.length > 0){
            [arr addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BOS_SERVER,url ]]]];
        }
    }
    self.m_arrPhoto = arr;


    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];

    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)

    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];

    // Present
    [self.navigationController pushViewController:browser animated:YES];

    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.m_arrPhoto.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.m_arrPhoto.count) {
        return [self.m_arrPhoto objectAtIndex:index];
    }
    return nil;
}


- (void)onHeadClicked:(NSString *)userId
{



}
@end

