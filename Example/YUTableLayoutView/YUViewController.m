//
//  YUViewController.m
//  YUTableLayoutView
//
//  Created by Yanyuxxxx on 12/02/2019.
//  Copyright (c) 2019 Yanyuxxxx. All rights reserved.
//

#import "YUViewController.h"
#import "YUTableLayoutView.h"
#import "Masonry.h"

@interface YUViewController () {
    NSInteger _count;
}

@property (nonatomic, strong) YUTableLayoutView *layoutView;

@property (nonatomic, strong) UILabel *kLabel;
@property (nonatomic, strong) UIButton *kButton;

@end

@implementation YUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _count = 4;
    
    [self.view addSubview:self.layoutView];
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    [self reloadRows];
}

- (void)reloadRows {
    __weak typeof(self) weakSelf = self;
    [self.layoutView clearAllRows];
    [self.layoutView beginOffset:15];
    [self.layoutView addRowOffset:10 block:^(UIView *row) {
        row.backgroundColor = [UIColor redColor];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
    }];
    [self.layoutView addRowOffset:10 block:^(UIView *row) {
        row.backgroundColor = [UIColor redColor];
        [row addSubview:weakSelf.kLabel];
        [weakSelf.kLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }];
    [self.layoutView addRowOffset:10 block:^(UIView *row) {
        row.backgroundColor = [UIColor greenColor];
        [row addSubview:weakSelf.kButton];
        [weakSelf.kButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
        }];
    }];
    for (int i = 0; i < _count; i++) {
        [self.layoutView addRowOffset:10 block:^(UIView *row) {
            row.backgroundColor = [UIColor yellowColor];
            [row mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(60);
            }];
        }];
    }
    [self.layoutView endOffset:15];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _count += 1;
    [self reloadRows];
}

- (void)kButtonClickHandle:(UIButton *)sender {
    _count -= 1;
    [self reloadRows];
}


#pragma mark - getter setter
- (YUTableLayoutView *)layoutView {
    if (_layoutView == nil) {
        _layoutView = [YUTableLayoutView new];
    }
    return _layoutView;
}

- (UILabel *)kLabel {
    if (_kLabel == nil) {
        _kLabel = [UILabel new];
        _kLabel.text = @"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文文字文字文字文字文字文字文字文字文字文字文字文字";
        _kLabel.numberOfLines = 0;
    }
    return _kLabel;
}

- (UIButton *)kButton {
    if (_kButton == nil) {
        _kButton = [UIButton new];
        [_kButton setTitle:@"按钮" forState:UIControlStateNormal];
        [_kButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_kButton addTarget:self action:@selector(kButtonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kButton;
}

@end
