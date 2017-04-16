//
//  AddNewCarcodeSelectViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/3/29.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#define NUM_CARCODE      7
#define WIDTH_CARCODE     ((int)MAIN_WIDTH > 320 ? 50 : 40)


#import "AddNewCarcodeSelectViewController.h"

@interface AddNewCarcodeSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *m_arrProvice;
@property(nonatomic,strong)NSArray *m_arrCharacter;
@property(nonatomic,strong)NSArray *m_arrNum;
@property(assign)NSInteger  m_inputIndex;
@property(nonatomic,strong)NSMutableDictionary *m_carcodeInfo;
@end

@implementation AddNewCarcodeSelectViewController

- (id)init
{
    
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.m_carcodeInfo = [NSMutableDictionary dictionary];
        self.m_inputIndex = 0;
        self.m_arrProvice = @[@"京",@"津",@"沪",@"渝",@"冀",
                              @"豫",@"云",@"辽",@"黑",@"湘",
                              @"皖",@"鲁",@"新",@"苏",@"浙",
                              @"赣",@"鄂",@"桂",@"甘",@"晋",
                              @"蒙",@"陕",@"吉",@"闽",@"贵",
                              @"粤",@"青",@"藏",@"川",@"宁",
                              @"琼"];
        self.m_arrCharacter = @[@"A",@"B",@"C",@"D",@"E",
                                @"F",@"G",@"H",@"I",@"J",
                                @"K",@"L",@"M",@"N",@"O",
                                @"P",@"Q",@"R",@"S",@"T",
                                @"U",@"V",@"W",@"X",@"Y",
                                @"Z",];
        self.m_arrNum = @[@"0",@"1",@"2",@"3",@"4",
                          @"5",@"6",@"7",@"8",@"9"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        self.tableView.tableHeaderView = self.inputView;
    }
    return self;
}

- (UIView *)inputView
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, WIDTH_CARCODE+20)];
    NSInteger sep = (MAIN_WIDTH-NUM_CARCODE*WIDTH_CARCODE)/(NUM_CARCODE+1);
    for(NSInteger i = 0;i<NUM_CARCODE;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(sep+i*(sep+WIDTH_CARCODE), 10, WIDTH_CARCODE, WIDTH_CARCODE)];
        btn.tag = i;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [btn addTarget:self action:@selector(inputBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:self.m_inputIndex == i ?PUBLIC_BACKGROUND_COLOR:UIColorFromRGB(0xcfcfcf)];
        [btn setTitle:self.m_carcodeInfo[@(i)] forState:UIControlStateNormal];
        [bg addSubview:btn];
    }
    return bg;
}

- (void)inputBtnClicked:(UIButton *)btn
{
    self.m_inputIndex = btn.tag;
    [self requestData:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    self.tableView.tableHeaderView = self.inputView;
    [self reloadDeals];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"填写车牌号"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-60, DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"确认" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)confirmBtnClicked
{
    if(self.m_carcodeInfo.allKeys.count < 7)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车牌号格式不正确" inSuperView:self.view  withDuration:1];
        return;
    }
    NSMutableString *carcode = [NSMutableString string];
    for(NSInteger i = 0;i<self.m_carcodeInfo.allKeys.count;i++)
    {
        for(NSInteger j = 0;i<self.m_carcodeInfo.allKeys.count;j++)
        {
            if(i == [self.m_carcodeInfo.allKeys[j]integerValue])
            {
                [carcode appendFormat:@"%@",self.m_carcodeInfo.allValues[j]];
                break;
            }
        }
      
    }
    [self.m_selectDelegate onInputedCarcode:carcode];
    [self backBtnClicked];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define cell_num   5.0

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_inputIndex == 0 ? 1 : 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.m_inputIndex == 0)
    {
        return @"选择省份";
    }
    else
    {
        if(section == 0)
        {
            return @"选择字母";
        }
        else
        {
            return @"选择数字";
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath.section];
}


- (NSInteger)high:(NSInteger)section
{
    if(self.m_inputIndex == 0)
    {
        if(section == 0)
        {
            return ceil(self.m_arrProvice.count*1.0/cell_num)*(WIDTH_CARCODE+20);
        }
    }
    else
    {
        if (section == 0)
        {
            return ceil(self.m_arrCharacter.count*1.0/cell_num)*(WIDTH_CARCODE+20);
        }
        else
        {
            return ceil(self.m_arrNum.count*1.0/cell_num)*(WIDTH_CARCODE+20);
            
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    if(self.m_inputIndex == 0)
    {
        if(indexPath.section == 0)
        {
            NSInteger sep = (MAIN_WIDTH-cell_num*WIDTH_CARCODE)/(cell_num+1);
            for(NSInteger i = 0;i<self.m_arrProvice.count;i++)
            {
                NSInteger row = i/cell_num;
                NSInteger coulmn = i%(NSInteger)cell_num;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(sep+coulmn*(sep+WIDTH_CARCODE),10+row*(WIDTH_CARCODE+20), WIDTH_CARCODE, WIDTH_CARCODE)];
                btn.layer.cornerRadius = 5;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.tag = i;
                [btn addTarget:self action:@selector(proviceInputBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
                [btn setTitle:self.m_arrProvice[i] forState:UIControlStateNormal];
                [cell addSubview:btn];
            }
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            NSInteger sep = (MAIN_WIDTH-cell_num*WIDTH_CARCODE)/(cell_num+1);
            for(NSInteger i = 0;i<self.m_arrCharacter.count;i++)
            {
                NSInteger row = i/cell_num;
                NSInteger coulmn = i%(NSInteger)cell_num;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(sep+coulmn*(sep+WIDTH_CARCODE), 10+row*(WIDTH_CARCODE+20), WIDTH_CARCODE, WIDTH_CARCODE)];
                btn.layer.cornerRadius = 5;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.tag = i;
                [btn addTarget:self action:@selector(characterInputBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
                [btn setTitle:self.m_arrCharacter[i] forState:UIControlStateNormal];
                [cell addSubview:btn];
            }
        }
        else
        {
            NSInteger sep = (MAIN_WIDTH-cell_num*WIDTH_CARCODE)/(cell_num+1);
            for(NSInteger i = 0;i<self.m_arrNum.count;i++)
            {
                NSInteger row = i/cell_num;
                NSInteger coulmn = i%(NSInteger)cell_num;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:CGRectMake(sep+coulmn*(sep+WIDTH_CARCODE), 10+row*(WIDTH_CARCODE+20), WIDTH_CARCODE, WIDTH_CARCODE)];
                btn.layer.cornerRadius = 5;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.tag = i;
                [btn addTarget:self action:@selector(numInputBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
                [btn setTitle:self.m_arrNum[i] forState:UIControlStateNormal];
                [cell addSubview:btn];
            }
            
        }


    }
    
    return cell;
}


- (void)proviceInputBtnClicked:(UIButton *)btn
{
    [PubllicMaskViewHelper showTipViewWith:self.m_arrProvice[btn.tag] inSuperView:self.view  withDuration:0.5];
    [self.m_carcodeInfo setObject:self.m_arrProvice[btn.tag] forKey:@(self.m_inputIndex)];
    self.m_inputIndex++;
    [self requestData:YES];
}

- (void)characterInputBtnClicked:(UIButton *)btn
{
    if(self.m_inputIndex>6)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车牌号位数已填满" inSuperView:self.view  withDuration:1];
        return;
    }
    [PubllicMaskViewHelper showTipViewWith:self.m_arrCharacter[btn.tag] inSuperView:self.view  withDuration:0.5];
    [self.m_carcodeInfo setObject:self.m_arrCharacter[btn.tag] forKey:@(self.m_inputIndex)];
    self.m_inputIndex++;
    [self requestData:YES];
}

- (void)numInputBtnClicked:(UIButton *)btn
{
    if(self.m_inputIndex>6)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车牌号位数已填满" inSuperView:self.view  withDuration:1];
        return;
    }
    [PubllicMaskViewHelper showTipViewWith:self.m_arrNum[btn.tag] inSuperView:self.view  withDuration:0.5];
    [self.m_carcodeInfo setObject:self.m_arrNum[btn.tag] forKey:@(self.m_inputIndex)];
    self.m_inputIndex++;
    [self requestData:YES];
}



@end
