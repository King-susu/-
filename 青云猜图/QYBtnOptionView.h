//
//  QYBtnOptionView.h
//  青云猜图
//
//  Created by qingyun on 16/2/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface QYBtnOptionView : UIView

@property (strong,nonatomic) void (^optionBtnAction)(UIButton *optionBtn);

//optionView中optionBtn的标题
@property (nonatomic, strong) NSArray *btnTitles;

+ (instancetype)optionView;
@end
