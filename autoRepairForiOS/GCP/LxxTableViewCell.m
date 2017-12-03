//
//  LxxTableViewCell.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "LxxTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation LxxTableViewCell

- (void)headClicked
{
    [self.m_delegate onHeadClicked:self.currentData.m_userId];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        m_head.layer.cornerRadius = 30;
        m_head.clipsToBounds = YES;
        m_head.userInteractionEnabled = YES;
        [self addSubview:m_head];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClicked)];
        [m_head addGestureRecognizer:tap];

        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,10,120, 18)];
        [m_nameLab setTextAlignment:NSTextAlignmentLeft];
        [m_nameLab setTextColor:[UIColor blackColor]];
        [m_nameLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_nameLab];

        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-160,10,150, 18)];
        [m_timeLab setTextAlignment:NSTextAlignmentRight];
        [m_timeLab setTextColor:UIColorFromRGB(0x333333)];
        [m_timeLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_timeLab];

        m_contentLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_nameLab.frame)+20,(MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+10)-10), 18)];
        [m_contentLab setTextAlignment:NSTextAlignmentLeft];
        m_contentLab.numberOfLines = 0;
        [m_contentLab setTextColor:UIColorFromRGB(0x999999)];
        [m_contentLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_contentLab];

        m_delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [m_delBtn setFrame:CGRectMake(MAIN_WIDTH-100, CGRectGetMaxY(m_contentLab.frame)+20, 40, 30)];
        [m_delBtn setTitle:@"删除" forState:0];
        [m_delBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [m_delBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_delBtn];

        m_commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [m_commentBtn setFrame:CGRectMake(MAIN_WIDTH-50, CGRectGetMaxY(m_contentLab.frame)+20, 40, 30)];
        [m_commentBtn setTitle:@"回复" forState:0];
        [m_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [m_commentBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_commentBtn];

        m_table = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
        m_table.dataSource = self;
        m_table.scrollEnabled = NO;
        m_table.delegate = self;
        [m_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:m_table];

        m_sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [m_sep setBackgroundColor:UIColorFromRGB(0xebebeb)];
        [self addSubview:m_sep];

        self.m_arrImageViews = [NSMutableArray array];
        m_picview1 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
        m_picview2 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
        m_picview3 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
        m_picview4 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
        m_picview5 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
        m_picview6 = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
        [self.m_arrImageViews addObject:m_picview1];
        [self.m_arrImageViews addObject:m_picview2];
        [self.m_arrImageViews addObject:m_picview3];
        [self.m_arrImageViews addObject:m_picview4];
        [self.m_arrImageViews addObject:m_picview5];
        [self.m_arrImageViews addObject:m_picview6];

        [m_picview1 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview2 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview3 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview4 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview5 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        [m_picview6 addTarget:self action:@selector(imgTap:) forControlEvents:UIControlEventTouchUpInside];
        m_picview1.tag = 1;
        m_picview2.tag = 2;
        m_picview3.tag = 3;
        m_picview4.tag = 4;
        m_picview5.tag = 5;
        m_picview6.tag = 6;

    }
    return self;
}

- (void)imgTap:(UIButton *)btn
{
    [self.m_delegate onTap:btn.tag-1 with:_currentData.m_arrPics];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurrentData:(ADTLxxItemInfo *)currentData
{
    _currentData = currentData;
    m_delBtn.hidden = ![currentData.m_userId isEqualToString:[LoginUserUtil singnalTel]];
    [m_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",currentData.m_userAvatar]] placeholderImage:[UIImage imageNamed:@"app_icon"]];
    [m_nameLab setText:currentData.m_userName];
    [m_timeLab setText:currentData.m_createTime];
    CGSize size = [FontSizeUtil sizeOfString:currentData.m_content withFont:m_contentLab.font withWidth:(MAIN_WIDTH-(30+CGRectGetWidth(m_head.frame)))];
    [m_contentLab setFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10, CGRectGetMaxY(m_nameLab.frame)+5, size.width, size.height)];
    [m_contentLab setText:currentData.m_content];

    [m_commentBtn setFrame:CGRectMake(m_commentBtn.frame.origin.x, CGRectGetMaxY(m_contentLab.frame)+10, m_commentBtn.frame.size.width, m_commentBtn.frame.size.height)];
    [m_delBtn setFrame:CGRectMake(m_delBtn.frame.origin.x, CGRectGetMaxY(m_contentLab.frame)+10, m_delBtn.frame.size.width, m_delBtn.frame.size.height)];
    NSArray *arr = currentData.m_arrPics;

    for(EGOImageView *img in self.m_arrImageViews){
        img.hidden = YES;
    }

    if(arr.count == 0){
        [m_sep setFrame:CGRectMake(0, CGRectGetMaxY(m_delBtn.frame)+10, MAIN_WIDTH, 0.5)];
    }

    for(int i=0;i<arr.count;i++){

        NSString *url = [arr objectAtIndex:i];
        if(url.length == 0){
            continue;
        }
        NSInteger sep = 10;
        NSInteger cell_num = 3;
        NSInteger width = (MAIN_WIDTH-(CGRectGetMaxX(m_head.frame)+sep*(cell_num+1)))/3;

        NSInteger row = i/cell_num;
        NSInteger coulmn = i%cell_num;

        EGOImageButton *img = [self.m_arrImageViews objectAtIndex:i];
        img.hidden = NO;
        img.frame= CGRectMake(CGRectGetMaxX(m_head.frame)+sep+(sep+width)*coulmn, CGRectGetMaxY(m_contentLab.frame)+sep+(sep+width)*row, width, width);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        [img setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BOS_SERVER,[arr objectAtIndex:i]]]];
        [self addSubview:img];
        [m_commentBtn setFrame:CGRectMake(m_commentBtn.frame.origin.x, CGRectGetMaxY(img.frame)+10, m_commentBtn.frame.size.width, m_commentBtn.frame.size.height)];
        [m_delBtn setFrame:CGRectMake(m_delBtn.frame.origin.x, CGRectGetMaxY(img.frame)+10, m_delBtn.frame.size.width, m_delBtn.frame.size.height)];
    }

    NSInteger high=0;
    for(NSDictionary *info in currentData.m_arrComments){
        NSString *content = [NSString stringWithFormat:@"%@回复:%@",info[@"userName"], info[@"content"]];
        CGSize size = [FontSizeUtil sizeOfString:content withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-130];
        high += (size.height > 40 ? size.height : 40);
    }
    [m_table setFrame:CGRectMake(0, CGRectGetMaxY(m_delBtn.frame), MAIN_WIDTH,high)];
    [m_table reloadData];
    [m_sep setFrame:CGRectMake(0, CGRectGetMaxY(m_table.frame), MAIN_WIDTH, 0.5)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.currentData.m_arrComments objectAtIndex:indexPath.row];
    NSString *content = [NSString stringWithFormat:@"%@回复:%@",info[@"userName"], info[@"content"]];
    CGSize size = [FontSizeUtil sizeOfString:content withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-130];
    return size.height > 40 ? size.height : 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentData.m_arrComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *info = [self.currentData.m_arrComments objectAtIndex:indexPath.row];

    NSString *content = [NSString stringWithFormat:@"%@回复:%@",info[@"sendername"], info[@"content"]];
    CGSize size = [FontSizeUtil sizeOfString:content withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-130];

    EGOImageView  * m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(80,((size.height>40 ? size.height :40)-30)/2, 30, 30)];
    [m_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"app_icon"]];
    m_head.layer.cornerRadius = 15;
    m_head.clipsToBounds = YES;
    [cell addSubview:m_head];

    UILabel  *m_contentLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,size.height>40 ? 0 : (40-size.height)/2,size.width,size.height)];
    [m_contentLab setTextAlignment:NSTextAlignmentLeft];
    m_contentLab.numberOfLines = 0;
    [m_contentLab setTextColor:UIColorFromRGB(0x333333)];
    [m_contentLab setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:m_contentLab];
    [m_contentLab setText:content];

    return cell;
}

- (void)commentBtnClicked
{
    [self.m_delegate onLxxTableViewCellDelegateForComment:self.currentData];
}

- (void)delBtnClicked
{
    [self.m_delegate onLxxTableViewCellDelegateForDel:self.currentData];
}

@end
