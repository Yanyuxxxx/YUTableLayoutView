//
//  YUTableLayoutView.h
//  YUTableLayoutView
//
//  Created by Yanyuxxxx on 2019/2/2.
//  Copyright © 2019 Yanyuxxxx.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YUTableLayoutView : UIView


#pragma mark - begin
- (YUTableLayoutView *)begin;
- (YUTableLayoutView *)beginOffset:(CGFloat)offset;


#pragma mark - end
- (YUTableLayoutView *)end;
- (YUTableLayoutView *)endOffset:(CGFloat)offset;


#pragma mark row
- (YUTableLayoutView *)addRow:(void(^)(UIView *row))block;
- (YUTableLayoutView *)addRowOffset:(CGFloat)offset block:(void(^)(UIView *row))block;


#pragma mark clear
- (void)clearAllRows;


@end
