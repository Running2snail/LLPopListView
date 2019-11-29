//
//  ViewController.m
//  LLPopListViewDemo
//
//  Created by wangll on 2019/11/29.
//  Copyright © 2019 王龙龙. All rights reserved.
//

#import "ViewController.h"
#import "LLPopListView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    NSLog(@"%f", point.x);
    NSArray *titles = @[@"发起群聊", @"添加朋友", @"扫一扫", @"收付款"];
    
    [LLPopListView showPopListViewWithPoint:point titles:titles selectTitle:@"" identifyPosition:LLPopListViewIdentifyLeft resultBlock:^(NSInteger selectIndex) {
        self.titleL.text = titles[selectIndex];
    }];
}

@end
