//
//  LOTTIESelectedViewController.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/23.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "LOTTIESelectedViewController.h"
#import "AnimationPreviewTableViewCell.h"

#define BASE_URL @"http://api.lottiefiles.com/"
#define RECENT_URL @"v1/recent"
#define POPULAR_URL @"v1/popular"
#define FEATURED_URL @"v2/featured"

@interface LOTTIESelectedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *recentButton;

@property (weak, nonatomic) IBOutlet UIButton *popularButton;

@property (weak, nonatomic) IBOutlet UIButton *featuredButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// <#Description#>
@property (nonatomic, strong) NSMutableArray *recentList;
/// <#Description#>
@property (nonatomic, assign) NSUInteger recentPage;

/// <#Description#>
@property (nonatomic, strong) NSMutableArray *popularList;
/// <#Description#>
@property (nonatomic, assign) NSUInteger popularPage;

/// <#Description#>
@property (nonatomic, strong) NSMutableArray *featuredList;
/// <#Description#>
@property (nonatomic, assign) NSUInteger featuredPage;

@end

@implementation LOTTIESelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewInit];
    [self dataInit];
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

- (NSMutableArray *)recentList {
    if (!_recentList) {
        _recentList = [NSMutableArray array];
    }
    return _recentList;
}

- (NSMutableArray *)popularList {
    if (!_popularList) {
        _popularList = [NSMutableArray array];
    }
    return _popularList;
}

- (NSMutableArray *)featuredList {
    if (!_featuredList) {
        _featuredList = [NSMutableArray array];
    }
    return _featuredList;
}

- (void)viewInit {
    self.recentButton.selected = true;
    [self.tableView registerClass:[AnimationPreviewTableViewCell class] forCellReuseIdentifier:@"animationCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)dataInit {
    self.recentPage = 1;
    self.popularPage = 1;
    self.featuredPage = 1;
    [self getTheRecentList];
    [self getThePopularList];
    [self getTheFeaturedList];
}

- (void)moreData {
    if (self.recentButton.selected) {
        self.recentPage++;
        [self getTheRecentList];
    } else if (self.popularButton.selected) {
        self.popularPage++;
        [self getThePopularList];
    } else if (self.featuredButton.selected) {
        self.featuredPage++;
        [self getTheFeaturedList];
    }
}

- (void)getTheRecentList {
    NSString *recentURLString = [BASE_URL stringByAppendingFormat:@"%@?%@", RECENT_URL, [self parameters:@{@"page":@(self.recentPage)}]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:recentURLString]];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"errorMessage:%@", error.description);
            } else {
                NSError *newError;
                NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
                NSLog(@"responseObject:%@", responseObject);
                NSArray *dataArray = responseObject[@"data"];
                [self.recentList addObjectsFromArray:dataArray];
                [self.tableView reloadData];
            }
        });
    }];
    
    [dataTask resume];
}

- (void)getThePopularList {
    NSString *popularURLString = [BASE_URL stringByAppendingFormat:@"%@?%@", POPULAR_URL, [self parameters:@{@"page":@(self.popularPage)}]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:popularURLString]];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"errorMessage:%@", error.description);
            } else {
                NSError *newError;
                NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
                NSLog(@"responseObject:%@", responseObject);
                NSArray *dataArray = responseObject[@"data"];
                [self.popularList addObjectsFromArray:dataArray];
                [self.tableView reloadData];
            }
        });
    }];
    
    
    [dataTask resume];
}

- (void)getTheFeaturedList {
    NSString *featuredURLString =
//    [BASE_URL stringByAppendingFormat:FEATURED_URL];
    [BASE_URL stringByAppendingFormat:@"%@?%@", FEATURED_URL, [self parameters:@{@"page":@(self.featuredPage)}]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:featuredURLString]];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"errorMessage:%@", error.description);
            } else {
                NSError *newError;
                NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
                NSLog(@"responseObject:%@", responseObject);
                NSArray *dataArray = responseObject[@"data"];
                [self.featuredList addObjectsFromArray:dataArray];
                [self.tableView reloadData];
            }
        });
    }];
    
    [dataTask resume];
}

- (IBAction)recentButtonClick:(UIButton *)sender {
    sender.selected = true;
    self.popularButton.selected = false;
    self.featuredButton.selected = false;
    [self.tableView reloadData];
}

- (IBAction)popularButtonClick:(UIButton *)sender {
    sender.selected = true;
    self.recentButton.selected = false;
    self.featuredButton.selected = false;
    [self.tableView reloadData];
}

- (IBAction)featuredButtonClick:(UIButton *)sender {
    sender.selected = true;
    self.recentButton.selected = false;
    self.popularButton.selected = false;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recentButton.selected) {
        return self.recentList.count;
    } else if (self.popularButton.selected) {
        return self.popularList.count;
    } else if (self.featuredButton.selected) {
        return self.featuredList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimationPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"animationCell" forIndexPath:indexPath];
    
    if (self.recentButton.selected) {
        [cell setAnimationDict:self.recentList[indexPath.row]];
    } else if (self.popularButton.selected) {
        [cell setAnimationDict:self.popularList[indexPath.row]];
    } else if (self.featuredButton.selected) {
        [cell setAnimationDict:self.featuredList[indexPath.row]];
    }
    
    return cell;
}

/**
 拼接字典数据

 @param parameters 参数
 @return 拼接后的字符串
 */
- (NSString *)parameters:(NSDictionary *)parameters {
    //创建可变字符串来承载拼接后的参数
    NSMutableString *parameterString = [NSMutableString new];
    //获取parameters中所有的key
    NSArray *parameterArray = parameters.allKeys;
    for (int i = 0;i < parameterArray.count;i++) {
    //根据key取出所有的value
        id value = parameters[parameterArray[i]];
    //把parameters的key 和 value进行拼接
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",parameterArray[i],value];
        if (i == parameterArray.count || i == 0) {
        //如果当前参数是最后或者第一个参数就直接拼接到字符串后面，因为第一个参数和最后一个参数不需要加 “&”符号来标识拼接的参数
            [parameterString appendString:keyValue];
        }else
        {
        //拼接参数， &表示与前面的参数拼接
            [parameterString appendString:[NSString stringWithFormat:@"&%@",keyValue]];
        }
    }
    return parameterString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
