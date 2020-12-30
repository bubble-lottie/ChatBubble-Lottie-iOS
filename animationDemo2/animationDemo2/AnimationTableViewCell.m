//
//  AnimationTableViewCell.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/12/29.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "AnimationTableViewCell.h"

@interface AnimationTableViewCell ()

/// <#Description#>
@property (nonatomic, strong) RAAnimationView *animationView;

/// <#Description#>
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation AnimationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.animationView];
    [self.contentView addSubview:self.contentLabel];
    
    //上下左右多留出10像素
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(TTextMessageCell_Text_PADDING/2);
        make.right.mas_lessThanOrEqualTo(-TTextMessageCell_Text_PADDING/2);
        make.top.mas_greaterThanOrEqualTo(Margin_Top+10);
        make.bottom.mas_lessThanOrEqualTo(-Margin_Bottom-10);
    }];
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentLabel.mas_left).mas_offset(-Margin_Left);
        make.right.mas_equalTo(_contentLabel.mas_right).mas_offset(Margin_Right);
        make.top.mas_equalTo(_contentLabel.mas_top).mas_offset(-Margin_Top);
        make.bottom.mas_equalTo(_contentLabel.mas_bottom).mas_offset(Margin_Bottom);
    }];
}

- (RAAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [[RAAnimationView alloc] init];
        
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _animationView.backgroundColor = [UIColor darkGrayColor];
    }
    return _animationView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textColor = [UIColor colorWithRed:(33.f/255.f) green:(33.f/255.f) blue:(33.f/255.f) alpha:1.0f];
    }
    return _contentLabel;
}

- (void)setModel:(TextAnimationModel *)model {
    _model = model;
    
    self.contentLabel.text = model.text;
    [self.animationView setAnimationWithContentsOfURL:model.animationURL cavasSize:model.animationSize];
    
    if ([model.text isEqualToString:@""]) {
        [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(model.defaultSize);
            make.center.mas_equalTo(0);
        }];
    } else {
        [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left).mas_offset(-Margin_Left);
            make.right.mas_equalTo(_contentLabel.mas_right).mas_offset(Margin_Right);
            make.top.mas_equalTo(_contentLabel.mas_top).mas_offset(-Margin_Top);
            make.bottom.mas_equalTo(_contentLabel.mas_bottom).mas_offset(Margin_Bottom);
        }];
    }
}

@end
