//
//  QYBtnView.m
//  青云猜图
//
//  Created by qingyun on 16/2/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBtnView.h"
#import "Common.h"
@implementation QYBtnView

+ (instancetype)answerViewBtnWithCount:(NSInteger)answerCount{
    QYBtnView *answerView = [[QYBtnView alloc]initWithFrame:CGRectMake(0, 0,QYScreenW , 40)];
    for (int i = 0; i < answerCount; i++) {
        //answerBtn的大小
        CGFloat answerBtnW = 40;
        CGFloat answerBtnH = 40;
        //两个相邻的answerBtn之间的距离
        CGFloat space = 20;
        //第一个answerBtn距离屏幕左边的间距
        CGFloat baseX = (QYScreenW - answerBtnW * answerCount - space * (answerCount - 1))/2;
        //计算当前answerBtn的位置
        CGFloat answerBtnX = baseX + (answerBtnW + space) * i;
        CGFloat answerBtnY = 0;
        //创建并添加answerBtn
        UIButton *answerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [answerView addSubview:answerBtn];
        //设置frame
        answerBtn.frame = CGRectMake(answerBtnX, answerBtnY, answerBtnW, answerBtnH);
        //设置背景图片
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer"] forState:UIControlStateNormal];
        [answerBtn setBackgroundImage:[UIImage imageNamed:@"btn_answer_highlighted"] forState:UIControlStateHighlighted];
        //设置标题颜色
        [answerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //添加监听事件
        [answerBtn addTarget:answerView action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return answerView;
}

- (void)clickBtn:(UIButton*)sender{
    if (_answerBtnAction) {
        _answerBtnAction(sender);
    }
}
- (NSMutableArray *)answerBtnIndexs{
    if (_answerBtnIndexs == nil) {
        //_answerBtnIndexs
        _answerBtnIndexs = [NSMutableArray array];
        for (int i = 0;i < self.subviews.count ; i ++) {
            //把需要填写的答案answerBtn的索引添加在_answerBtnIndexs中
            [_answerBtnIndexs addObject:@(i)];
        }
    }
    return _answerBtnIndexs;
}
//重写setFrame的方法，设置answerView的frame的时候，保证size保持不变
- (void)setFrame:(CGRect)frame{
    //1.获取初始化的时候的answerView的fram；
    CGRect originFrame = self.frame;
    //2.重置frame的origin
    originFrame.origin = frame.origin;
    //3.把最终的frame赋值给answerView
    [super setFrame:originFrame];
}

@end
