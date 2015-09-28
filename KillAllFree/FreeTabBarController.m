//
//  FreeTabBarController.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "FreeTabBarController.h"
#import "UIView+Common.h"
#import "AppListViewController.h"
#import "KillAllDefine.h"
@interface FreeTabBarController ()

@end

@implementation FreeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViewControllers];
    [self crateLanchAnimation];
}
/**
 *  创建 tabbar 的每个 item 对应的视图界面
 */
- (void)createViewControllers {
    
    /*
     <dict>
     <key>title</key>
     <string>专题</string>
     <key>iconName</key>
     <string>tabbar_subject</string>
     <key>className</key>
     <string>SubjectViewController</string>
     </dict>
     */
    
    NSArray *urlArray = @[kLimitUrl, kReduceUrl, kFreeUrl, kSubjectUrl, kHotUrl];
    NSArray *categoryArray = @[kLimitType, kReduceType, kFreeType, kSubjectType, kHotType];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Controllers" ofType:@"plist"];
    NSArray *vcArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *tabArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *vcDict in vcArray) {
        Class class = NSClassFromString(vcDict[@"className"]);
        AppListViewController *listVC = [[class alloc] init];
        UINavigationController *listNav = [[UINavigationController alloc] initWithRootViewController:listVC];
        listVC.categoryViewType = categoryArray[i];
        listVC.requestURL = urlArray[i++];
        listVC.title = vcDict[@"title"];
        listVC.tabBarItem.image = [UIImage imageNamed:vcDict[@"iconName"]];
        [tabArray addObject:listNav];
    }
    self.viewControllers = tabArray;
    
}
/**
 *  创建启动动画页面
 */
- (void)crateLanchAnimation {
    UIImageView *splshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
    // 取启动动画图片的路径
    NSString *splshImagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Defaultretein%d@2x",arc4random_uniform(7)+1] ofType:@"png"];
    splshImageView.image = [[UIImage alloc] initWithContentsOfFile:splshImagePath];
    [self.view addSubview:splshImageView];
    [UIView animateWithDuration:3.0 animations:^{
        splshImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [splshImageView removeFromSuperview];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
