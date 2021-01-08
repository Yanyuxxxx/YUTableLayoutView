//
//  YUTableLayoutView.h
//  YUTableLayoutView
//
//  Created by Yanyuxxxx on 2019/2/2.
//  Copyright © 2019 Yanyuxxxx.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUTableLayoutView : UIView

- (YUTableLayoutView *)begin;
- (YUTableLayoutView *)beginOffset:(CGFloat)offset;

- (YUTableLayoutView *)end;
- (YUTableLayoutView *)endOffset:(CGFloat)offset;

- (YUTableLayoutView *)addRow:(void(^)(UIView *row))block;
- (YUTableLayoutView *)addRowOffset:(CGFloat)offset block:(void(^)(UIView *row))block;

/**
 *  当UI元素过多时，clearAllRows方法会比较耗时，可以考虑适当优化
 *  当UI元素很少时，不会影响性能，可以使用clearAllRows重绘，增强可读性，可扩展性
 *
 *  优化方案：
 *  1、使用懒加载、缓存等方式避免UI元素重复创建
 *  2、当只有少部分row动态变化时，可以不使用clearAllRows，通过单独更新row的高度来实现模块的动态展示
 */
- (void)clearAllRows;


@end
