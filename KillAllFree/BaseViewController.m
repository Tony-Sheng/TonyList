//
//  BaseViewController.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+Common.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleWithName:self.title];
}
/**
 *  给导航修改 title
 *
 */
- (void)addTitleWithName:(NSString *)name {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor colorWithRed:30/255.f green:160/255.f blue:230/255.f alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}


- (void)addBarButtonItemWithTitle:(NSString *)title
                        imageName:(NSString *)imageName
                            frame:(CGRect)frame
                        aSelector:(SEL)aSelector
                           isLeft:(BOOL)isLeft {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width(frame), height(frame));
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 要判断下这个方法真实存在没
    if ([self respondsToSelector:aSelector]) {
        [button addTarget:self
                   action:aSelector
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft)
        self.navigationItem.leftBarButtonItem = barButtonItem;
    else
        self.navigationItem.rightBarButtonItem = barButtonItem;
    
    
    
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
