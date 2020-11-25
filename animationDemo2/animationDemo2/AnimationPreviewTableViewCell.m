//
//  AnimationPreviewTableViewCell.m
//  animationDemo2
//
//  Created by iOSzhang Inc on 20/9/23.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

#import "AnimationPreviewTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import <SDWebImage.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface AnimationPreviewTableViewCell ()

/// 播放器
@property (nonatomic, strong) AVPlayer *player;

/// 播放视图(没有的用图片)
@property (nonatomic, strong) UIImageView *playerView;

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// json地址
@property (nonatomic, strong) UILabel *jsonAddress;

@end

@implementation AnimationPreviewTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self viewInit];
    }
    return self;
}

- (void)viewInit {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.jsonAddress];
    [self.contentView addSubview:self.playerView];


    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(8);
    }];
    [self.jsonAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(-8);
    }];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W-100, SCREEN_W-100));
        make.top.mas_equalTo(_jsonAddress.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(-20);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标题";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}

- (UILabel *)jsonAddress {
    if (!_jsonAddress) {
        _jsonAddress = [[UILabel alloc] init];
        _jsonAddress.text = @"文件地址";
        _jsonAddress.font = [UIFont systemFontOfSize:13];
        _jsonAddress.textColor = [UIColor lightGrayColor];
        _jsonAddress.numberOfLines = 0;
    }
    return _jsonAddress;
}

- (UIImageView *)playerView {
    if (!_playerView) {
        _playerView = [[UIImageView alloc] init];
        _playerView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _playerView;
}

- (void)setAnimationDict:(NSDictionary *)animationDict {
    _animationDict = animationDict;
    
    self.titleLabel.text = animationDict[@"title"];
    if (animationDict[@"lottie_link"]) {
        self.jsonAddress.text = animationDict[@"lottie_link"];
    } else {
        self.jsonAddress.text = animationDict[@"file"];
    }
    
    if (animationDict[@"preview_video_url"] && ![animationDict[@"preview_video_url"] isEqual:NSNull.null]) {
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:animationDict[@"preview_video_url"]]];
        
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        playerLayer.frame = self.playerView.layer.bounds;
        
        [self.playerView.layer addSublayer:playerLayer];
        
        [self.player play];
    } else if (animationDict[@"preview_url"] && ![animationDict[@"preview_url"] isEqual:NSNull.null]) {
        [self.playerView sd_setImageWithURL:[NSURL URLWithString:animationDict[@"preview_url"]]];
    }
}

@end
