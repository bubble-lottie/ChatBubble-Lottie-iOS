//
//  TextAnimationModel.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/12/29.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "TextAnimationModel.h"



@implementation NSString (MYString)

+ (NSString *)randomChineseStringWithMinLength:(uint32_t)minLength maxLength:(uint32_t)maxLength {
    NSUInteger length = arc4random_uniform(maxLength-minLength)+minLength;
    
    return [self randomCreatChinese:length];
}

+ (NSString *)randomCreatChinese:(NSInteger)count {
    NSMutableString *randomChineseString = @"".mutableCopy;

    for(NSInteger i =0; i < count; i++){
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //随机生成汉字高位
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1 + 1);
        //随机生成汉子低位
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0 + 1);
        //组合生成随机汉字
        NSInteger number = (randomH<<8)+randomL;
        NSData*data = [NSData dataWithBytes:&number length:2];
        NSString*string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        [randomChineseString appendString:string];
    }
    return randomChineseString;
}

@end

@implementation TextAnimationModel

- (CGSize)animationSize {
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:self.text attributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:16]
    }];
    
    CGRect rect = [attStr boundingRectWithSize:CGSizeMake(TTextMessageCell_Text_Width_Max, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    //文本宽高
    
    size.width = MAX(size.width+Margin_Left+Margin_Right, self.defaultSize.width);
    size.height = MAX(size.height+Margin_Top+Margin_Bottom, self.defaultSize.height);

    return size;
}

+ (instancetype)randomModelWithURL:(NSURL *)url defaultSize:(CGSize)defaultSize {
    TextAnimationModel *model = [[TextAnimationModel alloc] init];
    
    model.text = [NSString randomChineseStringWithMinLength:1 maxLength:100];
    model.animationURL = url;
    model.defaultSize = defaultSize;
    
    return model;
}

- (NSString *)text {
    if (!_text) {
        _text = @"";
    }
    return _text;
}

@end


