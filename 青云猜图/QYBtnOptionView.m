//
//  QYBtnOptionView.m
//  青云猜图
//
//  Created by qingyun on 16/2/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBtnOptionView.h"

@implementation QYBtnOptionView

+ (instancetype)optionView
{
    //总列数
    int totalColumn = 7;
    //btnView的宽和高
    CGFloat btnViewW = 40;
    CGFloat btnViewH = 40;
    //两个相邻btn之间的距离
    CGFloat spaceX = (QYScreenW - btnViewW * totalColumn) / (totalColumn + 1);
    CGFloat spaceY = 25;
    CGFloat Y = [UIScreen mainScreen].bounds.size.height - 220;
    QYBtnOptionView *btnView = [[QYBtnOptionView alloc]initWithFrame:CGRectMake(0, Y, QYScreenW, 220)];
    for (int i = 0; i < 21; i ++) {
        //当前应用的行数和列数
        int hang = i / totalColumn;
        int lie = i % totalColumn;
        //计算每个btn的位置
        CGFloat btnViewX = spaceX * (lie + 1) + btnViewW * lie;
        CGFloat btnViewY = spaceY * (hang + 1) + btnViewH * hang;
        //创建并添加btn
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH);
        //        btn.backgroundColor = [UIColor greenColor];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_option_highlighted"] forState:UIControlStateHighlighted];
        //将btn添加在btnView上
        [btnView addSubview:btn];

    }
    return btnView;
}

- (void)setBtnTitles:(NSArray *)btnTitles
{
    _btnTitles = btnTitles;
    for (int i = 0; i < btnTitles.count; i ++) {
        UIButton *optionBtn = self.subviews[i];
        [optionBtn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [optionBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

}
- (void)clickBtn:(UIButton*)sender{
    if (_optionBtnAction) {
        _optionBtnAction(sender);
    }
}
@end
