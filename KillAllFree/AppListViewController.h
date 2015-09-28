//
//  AppListViewController.h
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "BaseViewController.h"
@class AFHTTPRequestOperationManager;
@interface AppListViewController : BaseViewController  {
    AFHTTPRequestOperationManager *_manager;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}

@property (nonatomic, copy) NSString *requestURL;
@property (nonatomic, copy) NSString *categoryViewType;
- (void)loadingData:(NSString *)url isMore:(BOOL)isMore;
@end
