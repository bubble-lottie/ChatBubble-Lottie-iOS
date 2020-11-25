//
//  ViewController.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/14.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "ViewController.h"
#import "Lottie.h"
#import <Masonry.h>
#import "RAAnimationView.h"

#import "SelectedViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SelectedViewControllerDelegate>

/// <#Description#>
@property (nonatomic, strong) UITableView *tableView;

/// <#Description#>
@property (nonatomic, strong) NSMutableDictionary *heightCache;

/// <#Description#>
@property (nonatomic, strong) NSMutableDictionary *widthCache;

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
    }
    return _tableView;
}

- (NSMutableDictionary *)heightCache {
    if (!_heightCache) {
        _heightCache = [NSMutableDictionary dictionary];
        [_heightCache setValue:@(92) forKey:@"10"];
    }
    return _heightCache;
}

- (NSMutableDictionary *)widthCache {
    if (!_widthCache) {
        _widthCache = [NSMutableDictionary dictionary];
        [_widthCache setValue:@(128) forKey:@"10"];
    }
    return _widthCache;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.heightCache[@(indexPath.row+10).stringValue] && self.widthCache[@(indexPath.row+10).stringValue]) {
        return ((NSNumber *)self.heightCache[@(indexPath.row+10).stringValue]).floatValue;
    }
    CGFloat height = arc4random()%300+40+20;
    [self.heightCache setValue:@(height) forKey:@(indexPath.row+10).stringValue];
    CGFloat wight = SCREEN_W-arc4random()%((int)SCREEN_W-60);
    [self.widthCache setValue:@(wight) forKey:@(indexPath.row+10).stringValue];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSNumber *viewHeight = [self.heightCache valueForKey:@(indexPath.row+10).stringValue];
    NSNumber *viewWidth = [self.widthCache valueForKey:@(indexPath.row+10).stringValue];
    
    if (!viewHeight.boolValue || !viewWidth.boolValue) {
        return cell;
    }
    
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:[RAAnimationView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSString *filePath;
    if (indexPath.row == 0) {
        filePath = [[NSBundle mainBundle] pathForResource:@"edgeBall_orgin" ofType:@"json"];
    } else {
        filePath = [[NSBundle mainBundle] pathForResource:@"edgeBall_test" ofType:@"json"];
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    RAAnimationView *animationView =
    [[RAAnimationView alloc] initWithContentsOfURL:fileURL
                                        canvasSize:CGSizeMake(viewWidth.floatValue, viewHeight.floatValue-20)];
    
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    animationView.backgroundColor = [UIColor darkGrayColor];
    
    [cell addSubview:animationView];
    
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((SCREEN_W-viewWidth.floatValue)/2);
        make.right.mas_equalTo(-(SCREEN_W-viewWidth.floatValue)/2);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RAAnimationView *animationView;
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:[RAAnimationView class]]) {
            animationView = (RAAnimationView *)subView;
        }
    }
    
    [animationView play];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RAAnimationView *animationView;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:[RAAnimationView class]]) {
            animationView = (RAAnimationView *)subView;
        }
    }
    
    [animationView play];
}

- (IBAction)selectedButtonItemClick:(UIBarButtonItem *)sender {
//    self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
}

#pragma mark - SelectedViewControllerDelegate
//- rel

@end
