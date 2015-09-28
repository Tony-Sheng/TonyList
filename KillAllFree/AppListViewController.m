//
//  AppListViewController.m
//  KillAllFree
//
//  Created by JackWong on 15/9/23.
//  Copyright (c) 2015年 JackWong. All rights reserved.
//

#import "AppListViewController.h"
#import "UIView+Common.h"
#import <AFNetworking/AFNetworking.h>
#import <JSONModel/JSONModel.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "KillAllDefine.h"
#import "AppModel.h"
#import "AppViewCell.h"
#import "SearchViewController.h"
#import "NSString+Tools.h"
#import "CategoryViewController.h"
#import "DetailViewController.h"
#import "JWCache.h"


@interface AppListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSString *_categoryID;
    
}

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    _categoryID = @"0";
    
    [self initializeApp];
}
/**
 *  初始化视图和请求
 */
- (void)initializeApp {
    _dataArray = [NSMutableArray array];
    [self initRequestManager];
    [self createTableView];
    [self initBarButtonItems];
    
}

- (void)initBarButtonItems {
    CGRect barRect = {{0,0},{44,30}};
    [self addBarButtonItemWithTitle:@"分类" imageName:@"buttonbar_action" frame:barRect aSelector:@selector(leftItemAction) isLeft:YES];
    [self addBarButtonItemWithTitle:@"设置" imageName:@"buttonbar_action" frame:barRect aSelector:@selector(rightItemAction) isLeft:NO];
    
}

- (void)leftItemAction {
//    NSLog(@"%s, (%@)",__func__,self.title);
    
    CategoryViewController *categoryViewController = [CategoryViewController new];
    [categoryViewController setCategoryIdBlock:^(NSString *categoryId){
//        NSLog(@"categoryId - - - -(%@)",categoryId);
        _categoryID = categoryId;
        [_tableView.header beginRefreshing];
        
    }];
    categoryViewController.title = @"分类";
    categoryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:categoryViewController animated:YES];
}

- (void)rightItemAction {
    NSLog(@"%s",__FUNCTION__);
}
/**
 *  创建表示图
 */
- (void)createTableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [self.view width], [self.view height]) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[AppViewCell class] forCellReuseIdentifier:@"appCell"];
    }

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [_tableView width], 44.0)];
    searchBar.placeholder = @"60万款应用,搜搜看";
    searchBar.delegate = self;
    _tableView.tableHeaderView = searchBar;
    _tableView.tableFooterView = [UIView new];

    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self prepareLoadData:NO];
    }];
    
    _tableView.header = refreshHeader;
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self prepareLoadData:YES];
    }];
    _tableView.footer = refreshFooter;
    [refreshHeader beginRefreshing];
   
}
- (void)refreshUI {
    [self prepareLoadData:NO];
}
- (void)initRequestManager {
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}

#pragma mark -
#pragma mark --RequestData
- (void)prepareLoadData:(BOOL)isMore {
    NSString *url = @"";
    NSInteger page = 1;
    if (isMore) {
        page = _dataArray.count/10 + 1;
    }
    if ([_categoryViewType isEqualToString:kHotType]) {
        url = [NSString stringWithFormat:_requestURL,page];
        
    }else if ([_categoryViewType isEqualToString:kSubjectType]) {
        url = [NSString stringWithFormat:_requestURL,page];
    }else {
        url = [NSString stringWithFormat:_requestURL,page,_categoryID];
    }
    [self loadingData:url isMore:isMore];
}

- (void)loadingData:(NSString *)url isMore:(BOOL)isMore {
    
    NSLog(@"-------------------->>>>>>%@",NSHomeDirectory());
//    NSLog(@"%@ --- %@",self.title,url);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *cacheData = [JWCache  objectForKey:MD5Hash(url)];
    if (cacheData) {
        
        AppModel *appModel = [[AppModel alloc] initWithData:cacheData error:nil];
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:appModel.applications];
        [_tableView reloadData];
        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }
    else {
    
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AppModel *appModel = [[AppModel alloc] initWithData:responseObject error:nil];
        if (!isMore) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:appModel.applications];
        [_tableView reloadData];
        !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        /**
         *  增加缓存
         */
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [JWCache setObject:responseObject forKey:MD5Hash(url)];
           
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         !isMore?[_tableView.header endRefreshing]:[_tableView.footer endRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
        
    }
}


#pragma mark -
#pragma mark --UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    SearchViewController *searchView = [[SearchViewController alloc] init];
    if ([_categoryViewType isEqualToString:kHotType]) {
        searchView.requestURL = SEARCH_HOT_URL;
    }else if ([_categoryViewType isEqualToString:kLimitType]) {
        searchView.requestURL  = SEARCH_LIMIT_URL;
    }else if ([_categoryViewType isEqualToString:kReduceType]) {
        searchView.requestURL  = SEARCH_REDUCE_URL;
    }else {
        searchView.requestURL  = SEARCH_FREE_URL;
    }
    searchView.searchText = URLEncodedString(searchBar.text);
    searchView.title = @"搜索结果";
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
     [searchBar resignFirstResponder];
    searchBar.text = @"";
}

#pragma mark -
#pragma mark --UITableViewDataSource 数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appCell" forIndexPath:indexPath];
    cell.applicationModel = _dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplicationModel *model = _dataArray[indexPath.row];
    DetailViewController *detail = [DetailViewController new];
    detail.applicationID = model.applicationId;
    detail.title = @"应用详情";
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
