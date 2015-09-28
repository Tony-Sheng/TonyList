//
//  SubjectViewController.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "SubjectViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "SubjectModel.h"
#import "SubjectTableViewCell.h"
#import "DetailViewController.h"
@interface SubjectViewController () <TouchAppDelegate>
@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [_tableView registerClass:[SubjectTableViewCell class] forCellReuseIdentifier:@"subCell"];
    _tableView.tableHeaderView = nil;
}

- (void)loadingData:(NSString *)url isMore:(BOOL)isMore {
    
    NSLog(@"%@ --- %@",self.title,url);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *modelArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *dict in modelArray) {
            SubjectModel *model = [[SubjectModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        
        [_tableView reloadData];
//        dispatch_async(dis, <#^(void)block#>)
        
        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.subjectModel = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 363;
}

- (void)touchAppForCell:(SubjectTableViewCell *)cell applicationId:(NSString *)applicationId {
    DetailViewController *detail = [DetailViewController new];
    detail.applicationID = applicationId;
    detail.title = @"应用详情";
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
