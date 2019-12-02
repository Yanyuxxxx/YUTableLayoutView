//
//  YUTableLayoutView.m
//  YUTableLayoutView
//
//  Created by Yanyuxxxx on 2019/2/2.
//  Copyright © 2019 Yanyuxxxx.com. All rights reserved.
//

#import "YUTableLayoutView.h"
#import "Masonry.h"

@interface YUTableLayoutView ()

@property (nonatomic, strong) MASViewAttribute *assistAttribute; // 布局辅助约束
@property (nonatomic, strong) NSMutableArray<UIView *> *rows;

@end

@implementation YUTableLayoutView


#pragma mark - begin
- (YUTableLayoutView *)begin {
    [self beginOffset:0];
    return self;
}

- (YUTableLayoutView *)beginOffset:(CGFloat)offset {
    self.assistAttribute = self.mas_top;
    [self addRowOffset:offset block:^(UIView *row) {
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }];
    return self;
}


#pragma mark - end
- (YUTableLayoutView *)end {
    return [self endOffset:0];
}

- (YUTableLayoutView *)endOffset:(CGFloat)offset {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.assistAttribute).offset(offset).priorityHigh();
    }];
    return self;
}


#pragma mark row
- (YUTableLayoutView *)addRow:(void(^)(UIView *))block {
    return [self addRowOffset:0 block:block];
}

- (YUTableLayoutView *)addRowOffset:(CGFloat)offset block:(void(^)(UIView *))block {
    UIView *row = [UIView new];
    [self addSubview:row];
    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.assistAttribute).offset(offset).priorityHigh();
    }];
    block(row);
    [self.rows addObject:row];
    self.assistAttribute = row.mas_bottom;
    return self;
}


#pragma mark clear
- (void)clearAllRows {
    for (UIView *row in self.rows) {
        [row removeFromSuperview];
    }
    [self.rows removeAllObjects];
}


#pragma mark - getter setter
- (NSMutableArray<UIView *> *)rows {
    if (_rows == nil) {
        _rows = [NSMutableArray new];
    }
    return _rows;
}

@end
