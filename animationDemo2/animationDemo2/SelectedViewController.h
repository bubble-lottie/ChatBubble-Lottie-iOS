//
//  SelectedViewController.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/10/30.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectedViewController;

@protocol SelectedViewControllerDelegate <NSObject>

- (void)selectedViewController:(SelectedViewController *)viewController reloadSelfBubble:(NSString *)bubblePath;

- (void)selectedViewController:(SelectedViewController *)viewController reloadOtherBubble:(NSString *)bubblePath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SelectedViewController : UIViewController

/// <#Description#>
@property (nonatomic, weak) id<SelectedViewControllerDelegate> delegate;

/// 当前展示自己的气泡的路径
@property (nonatomic, strong) NSString *selfFilePath;
/// 当前展示别人的气泡的路径
@property (nonatomic, strong) NSString *otherFilePath;

@end

NS_ASSUME_NONNULL_END
