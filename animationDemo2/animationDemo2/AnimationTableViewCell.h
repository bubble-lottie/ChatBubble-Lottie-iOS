//
//  AnimationTableViewCell.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/12/29.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottie.h"
#import <Masonry.h>
#import "RAAnimationView.h"
#import "TextAnimationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnimationTableViewCell : UITableViewCell

/// <#Description#>
@property (nonatomic, strong) TextAnimationModel *model;

@end

NS_ASSUME_NONNULL_END
