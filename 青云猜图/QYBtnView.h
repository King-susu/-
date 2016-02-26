//
//  QYBtnView.h
//  青云猜图
//
//  Created by qingyun on 16/2/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYBtnView : UIView

@property (strong,nonatomic) void (^answerBtnAction)(UIButton *answerBtn);

@property (nonatomic,strong) NSMutableArray *answerBtnIndexs;

+ (instancetype)answerViewBtnWithCount:(NSInteger)answerCount;

@end
