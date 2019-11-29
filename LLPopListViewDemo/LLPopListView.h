//
//  LLPopListView.h
//  Cashier
//
//  Created by wangll on 2019/10/15.
//  Copyright © 2019 wangll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,  LLIdentifyPosition) {
    LLPopListViewIdentifyLeft,
    LLPopListViewIdentifyRight,
    LLPopListViewIdentifyCenter,
};
typedef void(^LLPopResultBlock)(NSInteger selectIndex);

@interface LLPopListView : UIView


+ (void)showPopListViewWithFrame:(CGRect)frame
                          titles:(NSArray *)titles
                      selectTitle:(NSString *)selectTitle
                identifyPosition:(LLIdentifyPosition)identifyPosition
                     resultBlock:(LLPopResultBlock)resultBlock;

+ (void)showPopListViewWithPoint:(CGPoint)point
                          titles:(NSArray *)titles
                     selectTitle:(NSString *)selectTitle
                identifyPosition:(LLIdentifyPosition)identifyPosition
                     resultBlock:(LLPopResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
