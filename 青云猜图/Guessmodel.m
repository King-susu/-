//
//  Guessmodel.m
//  青云猜图
//
//  Created by qingyun on 16/2/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "Guessmodel.h"

@implementation Guessmodel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        //使用kvc把字典中的数据直接灌入模型属性
        _answer = dict[@"answer"];
//        NSLog(@"%@", dict[@"answer"]);
        _icon = dict[@"icon"];
//        NSLog(@"%@", dict[@"title"]);
        _title = dict[@"title"];
        _options = dict[@"options"];
        
        _answerCount = _answer.length;
    }
    return self;
}

@end
