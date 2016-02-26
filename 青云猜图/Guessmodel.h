//
//  Guessmodel.h
//  青云猜图
//
//  Created by qingyun on 16/2/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guessmodel : NSObject
 
@property (strong,nonatomic) NSString* answer;
@property (strong,nonatomic) NSString* icon;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSMutableArray* options;

@property (nonatomic) NSInteger answerCount;             //答案长度
@property (nonatomic) BOOL isFinish;
@property (nonatomic) BOOL isHind;                       //是否被提醒过

- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
