//
//  TextAnimationModel.h
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/12/29.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define Margin_Top (25)
#define Margin_Left (20)
#define Margin_Right (20)
#define Margin_Bottom (28)

#define TTextMessageCell_Text_PADDING (50)
#define TTextMessageCell_Text_Width_Max (SCREEN_W - TTextMessageCell_Text_PADDING)

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MYString)

/// 生成随机长度的随机汉字
/// @param minLength 最小长度
/// @param maxLength 最大长度
+ (NSString *)randomChineseStringWithMinLength:(uint32_t)minLength maxLength:(uint32_t)maxLength;

@end

@interface TextAnimationModel : NSObject

/// 文本
@property (nonatomic, copy) NSString *text;

/// 动画原始尺寸(用于无文本时定义)
@property (nonatomic) CGSize defaultSize;

/// 动画文件地址
@property (nonatomic, strong) NSURL *animationURL;


/// 动画视图尺寸
@property (nonatomic) CGSize animationSize;

+ (instancetype)randomModelWithURL:(NSURL *)url defaultSize:(CGSize)defaultSize;

@end

NS_ASSUME_NONNULL_END
