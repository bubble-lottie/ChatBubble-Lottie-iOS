//
//  ViewController.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/14.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>
#import "AnimationTableViewCell.h"

#import "SelectedViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SelectedViewControllerDelegate>

/// <#Description#>
@property (nonatomic, strong) UITableView *tableView;

/// 使用的数组
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 原貌对比数据数组
@property (nonatomic, strong) NSArray *sourseArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:AnimationTableViewCell.class forCellReuseIdentifier:@"animationCell"];
        
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMore)];
    }
    return _tableView;
}

- (NSArray *)sourseArray {
    if (!_sourseArray) {
        _sourseArray = @[
            [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"edgeBall_orgin" ofType:@"json"]],
        ];
    }
    return _sourseArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        for (int i=0; i<self.sourseArray.count; i++) {
            TextAnimationModel *model = [[TextAnimationModel alloc] init];
            model.animationURL = self.sourseArray[i];
            model.defaultSize = CGSizeMake(128, 72);
            
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)addMore {
    //此处开始添加随机出现的文本
    for (int i=0; i<10; i++) {
        [self.dataArray addObject:[TextAnimationModel randomModelWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"edgeBall_test" ofType:@"json"]] defaultSize:CGSizeMake(69, 40)]];
    }
    [self.tableView.mj_footer endRefreshing];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextAnimationModel *model = self.dataArray[indexPath.row];
    if (!model) {
        model = [TextAnimationModel randomModelWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"edgeBall_test" ofType:@"json"]] defaultSize:CGSizeMake(69, 40)];
        [self.dataArray insertObject:model atIndex:indexPath.row];
    }
    return model.animationSize.height+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"animationCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RAAnimationView *animationView = [self searchAnimationView:cell];
    
    [animationView play];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    RAAnimationView *animationView = [self searchAnimationView:cell];
    
    [animationView play];
}

- (IBAction)selectedButtonItemClick:(UIBarButtonItem *)sender {
//    self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
}

- (RAAnimationView *)searchAnimationView:(UIView *)superView {
    NSLog(@"单曲：%@", superView);
    RAAnimationView *animationView;
    for (UIView *subView in superView.subviews) {
        if ([subView isKindOfClass:[RAAnimationView class]]) {
            return (RAAnimationView *)subView;
        } else {
            animationView = [self searchAnimationView:subView];
            if (animationView != nil) {
                return animationView;
            }
        }
    }
    return animationView;
}

#pragma mark - SelectedViewControllerDelegate
//- rel

@end
