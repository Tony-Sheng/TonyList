//
//  SearchViewController.m
//  KillAllFree
//
//  Created by JackWong on 15/9/24.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.tableHeaderView = nil;
   
    
}
/**
 * 覆盖父类的方法,不执行父类的方法,只执行子类
 */
- (void)initBarButtonItems {
    
}
- (void)prepareLoadData:(BOOL)isMore {
    NSString *url = @"";
    NSInteger page = 1;
    if (isMore) {
        page = _dataArray.count/10 + 1;
    }
    url = [NSString stringWithFormat:self.requestURL,page,_searchText];
    
    [self loadingData:url isMore:isMore];
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
