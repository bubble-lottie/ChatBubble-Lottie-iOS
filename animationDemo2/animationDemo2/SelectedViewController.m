//
//  SelectedViewController.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/10/30.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "SelectedViewController.h"
#import "RASelectedTableViewCell.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface SelectedViewController ()<UITableViewDelegate, UITableViewDataSource>

/// <#Description#>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate


@end
