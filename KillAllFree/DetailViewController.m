//
//  DetailViewController.m
//  KillAllFree
//
//  Created by JackWong on 15/9/25.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "DetailViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import "KillAllDefine.h"
#import "AppDetailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "NearApplicationModel.h"
#import "DBManager.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController ()<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate> {
    UIScrollView *_bottomScrollView;
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_typeLabel;
    UIScrollView *_appSSScrollView;
    UILabel *_detailLabel;
    AppDetailModel *_appDetail;
    UIImageView *_detailImageView;
    NSMutableArray *_nearsArray;
    UIScrollView *_nearScrollView;
    UIImageView *_nearImageView;
    BOOL _isFavourite;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    _nearsArray = [NSMutableArray array];
//    _isFavourite = YES;
    [self createDetailViews];
    [self loadAppDetailData];
    
    
}

- (void)createDetailViews {
    CGFloat leftMargin = 15;
    CGFloat topMargin = 10;
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width(self.view.frame),height(self.view.frame))];
    _bottomScrollView.delaysContentTouches = NO;
    [self.view addSubview:_bottomScrollView];
    _detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width(self.view.frame) - 2*leftMargin, 280)];
    _detailImageView.image = [UIImage imageNamed:@"appdetail_background"] ;
    _detailImageView.userInteractionEnabled = YES;
    [_bottomScrollView addSubview:_detailImageView];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, 70, 70)];
    _iconImageView.layer.cornerRadius = 3.0;
    _iconImageView.layer.masksToBounds = YES;
    [_detailImageView addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_iconImageView) + 5, minY(_iconImageView), width(_detailImageView.frame) - width(_iconImageView.frame) - 15, 25)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_detailImageView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(_titleLabel), maxY(_titleLabel) + 5, width(_titleLabel.frame), 20)];
    _priceLabel.textColor = [UIColor lightGrayColor];
    [_detailImageView addSubview:_priceLabel];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(_titleLabel), maxY(_priceLabel) + 5, width(_titleLabel.frame), 20)];
    _typeLabel.textColor = [UIColor lightGrayColor];
    [_detailImageView addSubview:_typeLabel];
    
    CGFloat buttonWidth = (width(_detailImageView.frame)-6.0)/3.0;
    NSArray *buttonTitleArray = @[@"分享", @"收藏" , @"下载"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"Detail_btn_left"] forState:UIControlStateNormal];
        }else if (i == 1) {
            [button setBackgroundImage:[UIImage imageNamed:@"Detail_btn_middle"] forState:UIControlStateNormal];
        }else {
            [button setBackgroundImage:[UIImage imageNamed:@"Detail_btn_right"] forState:UIControlStateNormal];
        }
        button.frame = CGRectMake(i*buttonWidth +3.0, maxY(_iconImageView)+ 5, buttonWidth, 45);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.tag = 1000 + i;
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_detailImageView addSubview:button];
    }
    [self applicationFavourite];
    _appSSScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftMargin, maxY(_iconImageView) + 45 + 5 + 5 , width(_detailImageView.frame) - leftMargin * 2, 100)];
    [_detailImageView addSubview:_appSSScrollView];
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textColor = [UIColor lightGrayColor];
    _detailLabel.font = [UIFont systemFontOfSize:15];
    [_detailImageView addSubview:_detailLabel];
    
    _nearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, maxY(_detailLabel) + 20, width(_bottomScrollView.frame) - 15*2, 100)];
    _nearImageView.image = [UIImage imageNamed:@"appdetail_recommend"];
    _nearImageView.userInteractionEnabled = YES;
    [_bottomScrollView addSubview:_nearImageView];
    _nearScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _nearScrollView.delaysContentTouches = NO;
    [_nearImageView addSubview:_nearScrollView];
   
    
    
    

}
- (void)applicationFavourite {

    
    _isFavourite = [[DBManager sharedManager] isExistAppForAppId:_appDetail.applicationId recordType:_appDetail.categoryName];
   
    
//    NSLog(@"-----------------%d",_isFavourite);
    if (_isFavourite) {
        
//        NSLog(@"-----##########-------%d",_isFavourite);
        UIButton *button = (UIButton *)[_detailImageView viewWithTag:1001];
        [button setTitle:@"已收藏" forState:UIControlStateNormal];
        button.enabled = NO;
        
    }
}

- (void)loadAppDetailData {
    NSString *url = [NSString stringWithFormat:kDetailUrl,_applicationID];
    
    NSLog(@"^^^^^^^^^^^^^^^^^^%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           _appDetail = [[AppDetailModel alloc] initWithData:responseObject error:nil];
             [self laodNearApps];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark -
#pragma mark -- 


#warning
- (void)buttonAction:(UIButton *)button {
   
    
    NSInteger btnTag = button.tag - 1000;
    if (btnTag == 1) {
        if (_isFavourite) {
            return;
        }
        [[DBManager sharedManager] insertModel:_appDetail recordType:_appDetail.categoryName];
        [self applicationFavourite];
        
    }
    if (btnTag == 2) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appDetail.itunesUrl]];
    }
    if (btnTag == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"邮件",@"短信", nil];
        [actionSheet showInView:self.view];
    }
}

-  (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"%ld",buttonIndex);
    if (buttonIndex == 0) {
    
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
            //给指定的人发送短信
            message.recipients = @[@(10086),@(18317890668)];
            message.messageComposeDelegate = self;
            message.body = [NSString stringWithFormat:@"我们的应用真不错，赶快下载个吧!!下载地址是：%@",_appDetail.itunesUrl];
            [self presentViewController:message animated:YES completion:^{
                
            }];
        }
        
    }else {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
            mailView.mailComposeDelegate = self;
            [mailView setToRecipients:@[@"18317890668m0@sina.cn"]];
            [mailView setCcRecipients:@[@"shengtengda@qq.com"]];
            [mailView setSubject:@"这个APP 真棒"];
            [mailView  setMessageBody:[NSString stringWithFormat:@"赶快点击吧,下载有惊喜%@",_appDetail.itunesUrl ]isHTML:YES];
            [mailView addAttachmentData:UIImagePNGRepresentation([UIImage imageNamed:@"account_candou"]) mimeType:@"image/png" fileName:@"icon.png"];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件发送取消");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件保存草稿");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件发送");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"信息发送取消");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"信息发送失败");
            break;
        case MessageComposeResultSent:
            NSLog(@"信息发送成功");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)refreshUI {
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_appDetail.iconUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
    _titleLabel.text = _appDetail.name;
    NSString *string = @"";
    if ([_appDetail.priceTrend isEqualToString:@"limited"]) {
        string = @"限免中";
    }else if ([_appDetail.priceTrend isEqualToString:@"sales"]) {
        string = @"降价中";
    }else if ([_appDetail.priceTrend isEqualToString:@"free"]) {
        string = @"免费中";
    }
    _priceLabel.text = [NSString stringWithFormat:@"原价:￥%.2f  %@  %@MB",[_appDetail.lastPrice floatValue],string,_appDetail.fileSize];
    
    _typeLabel.text = [NSString stringWithFormat:@"类型:%@     评分:%@",_appDetail.categoryName,_appDetail.starCurrent];
   
    
    NSInteger phototsCount = _appDetail.photos.count;
    CGFloat buttonWidth = (width(_appSSScrollView.frame) - 5*4)/5;
    for (int i = 0; i < phototsCount; i++) {
        PhotoModel *photo = _appDetail.photos[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonWidth + i*5, 10, buttonWidth, 80);
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:photo.smallUrl] forState:UIControlStateNormal];
        [_appSSScrollView addSubview:button];
        
    }
    _appSSScrollView.delaysContentTouches = NO;
    _appSSScrollView.contentSize = CGSizeMake(phototsCount*buttonWidth + (phototsCount-1)*5, 100);
    
    CGFloat detailLabelWidht = width(_bottomScrollView.frame) - 15*2;
     _detailLabel.text = _appDetail.appDescription;
    
    CGFloat detailLabelHeight = [self heightForRow:_appDetail.appDescription width:detailLabelWidht labelFont:[UIFont systemFontOfSize:15]];
    
    _detailLabel.frame = CGRectMake(0, maxY(_appSSScrollView) + 5, detailLabelWidht, detailLabelHeight);
    
    _nearImageView.frame =  CGRectMake(15, maxY(_detailLabel) + 20, width(_bottomScrollView.frame) - 15*2, 100);
    
    _nearScrollView.frame = CGRectMake(0, 20, width(_nearImageView.frame), 80);
    NSInteger nearAppCount = _nearsArray.count;
    CGFloat nearbuttonWidth = (width(_nearScrollView.frame) - 5*4)/5;
    for (int i = 0; i < nearAppCount; i++) {
        NearApplicationModel *nearAppModel = _nearsArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*nearbuttonWidth + i*5, 10, nearbuttonWidth, 80);
        button.tag = 2000 + i;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:nearAppModel.iconUrl] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(appIConTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_nearScrollView addSubview:button];
        
    }
    _detailImageView.frame = CGRectMake(15, 15, width(self.view.frame) - 2*15, maxY(_detailLabel)+5 + 15);
    _bottomScrollView.contentSize = CGSizeMake(width(self.view.frame), maxY(_nearImageView) + 15);
}

- (void)appIConTouch:(UIButton *)button {
    NSInteger btnTag = button.tag - 2000;
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.applicationID = [(NearApplicationModel *)_nearsArray[btnTag] applicationId];
    detail.title = @"应用详情";
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)laodNearApps {
    NSString *url = [NSString stringWithFormat:kNearAppUrl,116.344539,40.034346];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *modelDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        for (NSDictionary *nearModelDict in modelDict[@"applications"]) {
           NearApplicationModel *model = [NearApplicationModel new];
            [model setValuesForKeysWithDictionary:nearModelDict];
            [_nearsArray addObject:model];
        }
        [self refreshUI];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (CGFloat)heightForRow:(NSString *)aString width:(CGFloat)widht labelFont:(UIFont *)labelFont {
    CGSize size = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        size = [aString boundingRectWithSize:CGSizeMake(widht, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:labelFont}  context:nil].size;
    } else {
        size = [aString sizeWithFont:labelFont constrainedToSize:CGSizeMake(widht, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
   
    return size.height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
