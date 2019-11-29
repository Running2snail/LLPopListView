//
//  LLPopListView.m
//  Cashier
//
//  Created by wangll on 2019/10/15.
//  Copyright © 2019 wangll. All rights reserved.
//

#import "LLPopListView.h"

#define IdentifyHeight 7
#define RadiusWidth 6
#define PopViewWidth 120
#define EdgeWidth 10
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface LLPopListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView  *popBackView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) LLPopResultBlock resultBlock;
@property (nonatomic, copy) NSString *selectTitle;
@property (nonatomic, assign) LLIdentifyPosition identifyPosition;

@end

@implementation LLPopListView

+ (void)showPopListViewWithFrame:(CGRect)frame titles:(NSArray *)titles selectTitle:(NSString *)selectTitle identifyPosition:(LLIdentifyPosition)identifyPosition resultBlock:(LLPopResultBlock)resultBlock;
{
    LLPopListView *popView = [[LLPopListView alloc] initWithFrame:frame titles:titles identifyPosition:identifyPosition resultBlock:resultBlock];
    popView.selectTitle = selectTitle;
    [popView show];
}

+ (void)showPopListViewWithPoint:(CGPoint)point titles:(NSArray *)titles selectTitle:(NSString *)selectTitle identifyPosition:(LLIdentifyPosition)identifyPosition resultBlock:(LLPopResultBlock)resultBlock;
{
    CGRect frame = [self getFrameWithPoint:point count:titles.count];
    LLPopListView *popView = [[LLPopListView alloc] initWithFrame:frame titles:titles identifyPosition:identifyPosition resultBlock:resultBlock];
    popView.selectTitle = selectTitle;
    [popView show];
}


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles identifyPosition:(LLIdentifyPosition)identifyPosition resultBlock:(LLPopResultBlock)resultBlock
{
    if (self = [super init]) {
        self.titles = titles;
        self.resultBlock = resultBlock;
        self.identifyPosition = identifyPosition;
        CGPoint anchorPoint = CGPointMake(0.2, 0);
        if (_identifyPosition == LLPopListViewIdentifyCenter) {
            anchorPoint = CGPointMake(0.5, 0);
        } else if (_identifyPosition == LLPopListViewIdentifyRight) {
            anchorPoint = CGPointMake(0.8, 0);
        }
        self.layer.anchorPoint = anchorPoint;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setIdentifyPosition:(LLIdentifyPosition)identifyPosition
{
    _identifyPosition = identifyPosition;
    
}


- (UIView *)popBackView
{
    if (!_popBackView) {
        self.popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        _popBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismiss)];
        [_popBackView addGestureRecognizer: tap];
    }
    return _popBackView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7, CGRectGetWidth(self.frame), 44 * _titles.count) style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}


+ (CGRect)getFrameWithPoint:(CGPoint)point count:(NSInteger)count
{
    CGFloat left = PopViewWidth * 0.2;
    if (point.x + PopViewWidth * 0.8 + EdgeWidth > SCREENW) {
        left = SCREENW - PopViewWidth - EdgeWidth;
    } else {
        left = point.x - left;
        if (left < EdgeWidth) {  left = EdgeWidth;  }
    }
    return CGRectMake(left, point.y, PopViewWidth, count * 44 + 7);
}

- (void)show
{
    [self.tableView reloadData];
    [self setNeedsDisplay];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self.popBackView];
    [window addSubview:self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    _popBackView.alpha = 0;
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self->_popBackView.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self->_popBackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self->_popBackView removeFromSuperview];
    }];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [[UIColor whiteColor] setFill];
    bezierPath.lineWidth = 0;
    CGPoint startPoint = CGPointMake(width * 0.2, IdentifyHeight);
    if (_identifyPosition == LLPopListViewIdentifyRight) {
        startPoint = CGPointMake(width * 0.8 - IdentifyHeight * 2, IdentifyHeight);
    } else if (_identifyPosition == LLPopListViewIdentifyCenter) {
        startPoint = CGPointMake(width / 2 - IdentifyHeight, IdentifyHeight);
    }
    [bezierPath moveToPoint:startPoint];
    [bezierPath addLineToPoint:CGPointMake(startPoint.x + IdentifyHeight, 0)];
    [bezierPath addLineToPoint:CGPointMake(startPoint.x + IdentifyHeight * 2, IdentifyHeight)];
    [bezierPath addLineToPoint:CGPointMake(width - RadiusWidth, IdentifyHeight)];
    [bezierPath addArcWithCenter:CGPointMake(width - RadiusWidth, IdentifyHeight+RadiusWidth) radius:RadiusWidth startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(width, height - RadiusWidth)];
    [bezierPath addArcWithCenter:CGPointMake(width - RadiusWidth,  height - RadiusWidth) radius:RadiusWidth startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(RadiusWidth, height)];
    [bezierPath addArcWithCenter:CGPointMake(RadiusWidth, height - RadiusWidth) radius:RadiusWidth startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, RadiusWidth)];
    [bezierPath addArcWithCenter:CGPointMake(RadiusWidth, IdentifyHeight+RadiusWidth) radius:RadiusWidth startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    [bezierPath closePath];
    [bezierPath fill];
    [bezierPath stroke];
}


#pragma mark tableViewDelegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"titleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    cell.textLabel.text = _titles[indexPath.row];
    if (_selectTitle.length && [_titles containsObject:_selectTitle]) {
        NSInteger index = [_titles indexOfObject:_selectTitle];
        if (indexPath.row == index) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
          cell.textLabel.textColor = [UIColor grayColor];
        }
    } else {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultBlock) {
        [self dismiss];
        self.resultBlock(indexPath.row);
    }
}


@end
