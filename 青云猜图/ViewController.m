//
//  ViewController.m
//  青云猜图
//
//  Created by qingyun on 16/2/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "Guessmodel.h"
#import "QYBtnOptionView.h"
#import "QYBtnView.h"
@interface ViewController ()
{
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UIButton *datuBtn;
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UIImageView *questionview;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *helpLable;
@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UIButton *maxBtn;
@property (weak, nonatomic) IBOutlet UIButton *cornbtn;
@property (strong,nonatomic) UIButton* btn;

@property (strong,nonatomic) NSArray* question;
@property (nonatomic, strong) QYBtnView *answerView;
@property (nonatomic, strong) Guessmodel *model;
@property (nonatomic,strong) QYBtnOptionView *optionView;


@end

@implementation ViewController

- (NSArray*)question{
    if (_question == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
        NSArray* array = [NSArray arrayWithContentsOfFile:path];
        //声明可变的数组，存放model
        NSMutableArray* imagemodel = [NSMutableArray array];
        for (NSDictionary* dict in array) {
            Guessmodel*images = [[Guessmodel alloc]initWithDictionary:dict];
            [imagemodel addObject:images];
        }
        _question = imagemodel;
    }
    return _question;
}
//更新图片
- (void)updateImage{
    index = index % self.question.count;
    //获取当前图片对应的model
    _model = self.question[index];
    //如果index题目已经回答过跳转下一题
    if (_model.isFinish) {
        [self nBtn];
        return;
    }
    //更改numberLable的文本
    _numberLable.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,self.question.count];
    //更改icon的图片
    _questionview.image = [UIImage imageNamed:_model.icon];
    //更改helpLable的文本
    _helpLable.text = _model.title;
    //添加answerView
    [_answerView removeFromSuperview];
    QYBtnView *answerView = [QYBtnView answerViewBtnWithCount:_model.answerCount];
    [self.view addSubview:answerView];
    //frame
    answerView.frame = CGRectMake(0, 390, 0, 0);
    _answerView = answerView;
    //answerBtn的点击事件
    __weak ViewController *weakself = self;
    answerView.answerBtnAction = ^(UIButton *answerBtn){
        [weakself answerBtnAction:answerBtn];
    };
    
    //更改optionbtn信息
    _optionView = [QYBtnOptionView optionView];
    [self.view addSubview:_optionView];
    //对btnTitle赋值
    _optionView.btnTitles = _model.options;
    //optionBtn的点击事件
    _optionView.optionBtnAction = ^(UIButton *optionBtn){
    //处理optionBtn的点击事件
        [weakself optionBtnAction:optionBtn];
    };
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
       [self updateImage];
   
}
- (IBAction)nextBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1://提示
            [self hint:sender];
            break;
        case 2://大图
            [self maxBtn:sender];
            break;
        case 3://帮助
            
            break;
        case 4://下一题
            [self nBtn];
            break;
        case 5://缩小
            [self smallBtn:sender];
            break;
        default:
            break;
    }
}
#pragma mark 功能键的实现方法
//下一题
- (void)nBtn{
    _tipBtn.enabled = YES;
    [_optionView removeFromSuperview];
    //定义一个bool值来表示通关
    __block BOOL isPass = YES;
    [self.question enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Guessmodel *question = (Guessmodel *)obj;
        if (!question.isFinish) {
            isPass = NO;
            *stop = YES;
        }
    }];
    //通关
    if (isPass) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"恭喜你通关了，是否再来一次" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.question enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Guessmodel *question = (Guessmodel *)obj;
                question.isFinish = NO;
            }];
            index = -1;
            [self nBtn];
        }];
        
        [alertController addAction:noAction];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    //更改索引
    index++;
    [self updateImage];
}
//放大
- (void)maxBtn:(UIButton *)sender{
        [UIView animateWithDuration:0.5 animations:^{
            _questionview.transform = CGAffineTransformScale(_questionview.transform, 1.2, 1.2);
            _maxBtn.backgroundColor = [UIColor yellowColor];
            _maxBtn.alpha = 0.5;
        }];
}
//缩小
- (void)smallBtn:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        _questionview.transform = CGAffineTransformIdentity;
        _maxBtn.alpha = 0;
    }];

}
//提示
- (void)hint:(UIButton *)sender{
//判断当前金币数是否将要花费的金币
    if ([_cornbtn.currentTitle integerValue] < 1000) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"金币不足，请充值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self changeCoin:10000];
        }];
        [alertController addAction:noAction];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    //取出当前需要填写的answerBtn对应的正确答案
    Guessmodel* question = self.question[index];
    //遍历_answerView的子视图找到已经填充的错误答案的answerBtn，并模拟点击answerBtn
    [_answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *answerBtn = (UIButton *)obj;
        NSRange range = NSMakeRange(idx, 1);
        NSString *currentitle = [question.answer substringWithRange:range];
        //判断当前的answerBtn没有标题，并且标题是错误的
        if (answerBtn.currentTitle.length != 0 && ![answerBtn.currentTitle isEqualToString:currentitle]) {
            //模拟点击answerBtn
            [self answerBtnAction:answerBtn];
        }
    }];
    NSInteger index1 = [_answerView.answerBtnIndexs.firstObject integerValue];
    NSRange range = NSMakeRange(index1, 1);
    NSString *answerBtntitle = [question.answer substringWithRange:range];

    [_optionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *optionBtn = (UIButton *)obj;
        if ([optionBtn.currentTitle isEqualToString:answerBtntitle]) {
            //减少金币
            [self changeCoin:-1000];
            //标题提示状态
            question.isHind = YES;
            //根据正确答案模拟optionBtn的点击事件
            [self optionBtnAction:optionBtn];
            
            *stop = YES;
        }
    }];
}

#pragma mark -answerBtn和optionBtn点击事件
//answerBtn的点击事件
- (void)answerBtnAction:(UIButton *)answerBtn{
    if (answerBtn.currentTitle.length == 0) {
        return;
    }
    //显示optionView上对应的optionBtn
    UIButton *optionbtn = [_optionView viewWithTag:answerBtn.tag];
    optionbtn.hidden = NO;
    optionbtn.tag = answerBtn.tag = 0;
    //清除answerBtn的标题
    [answerBtn setTitle:nil forState:UIControlStateNormal];
    //更改answerBtn的标题的颜色（黑色）
    [self changeColor:[UIColor blackColor]];
    
    //把answerBtn在answerView的subViews中对应的索引，添加到answerBtnIndexs中，确保UI界面上需要填写的answerBtn跟answerBtnIndexs一致
    NSInteger answerIndex = [_answerView.subviews indexOfObject:answerBtn];
    [_answerView.answerBtnIndexs addObject:@(answerIndex)];
    //对answerBtnIndexs数组进行排序，确保填写的answerBtnTitle的时候是从左至右的。
    NSArray *array = [_answerView.answerBtnIndexs sortedArrayUsingSelector:@selector(compare:)];
    _answerView.answerBtnIndexs = [NSMutableArray arrayWithArray:array];
}
//optionBtn的点击事件
- (void)optionBtnAction:(UIButton *)optionBtn{
    //判断answerBtnIndexs.count != 0
    if (_answerView.answerBtnIndexs.count > 0) {
        //隐藏optionBtn
        optionBtn.hidden = YES;
        //把optionBtn的标题填写到相应的answerBtn上   取标题，currentTitle当前界面显示的标题
        NSString* title = optionBtn.currentTitle;
        //取出需要填写的answerBtn的索引
        NSInteger answerIndex = [_answerView.answerBtnIndexs.firstObject integerValue];
        //根据索引取出answerBtn
        UIButton *answerBtn = _answerView.subviews[answerIndex];
        [answerBtn setTitle:title forState:UIControlStateNormal];
        //把answerView中的answerBtnIndexs中对应的索引删除，确保UI界面上需要填写的answerBtn跟answerBtnIndexs一致
        [_answerView.answerBtnIndexs removeObjectAtIndex:0];
        //把optionBtn和answerBtn的tag值设置一致，便于点击answerBtn的时候通过tag值找到optionBtn
        optionBtn.tag = answerBtn.tag = 100 + answerIndex;
    }

    //判断是否填充完毕（把answerView上所有的answerBtn标题填充完整）
    if (_answerView.answerBtnIndexs.count == 0) {
        NSMutableString *answerString = [NSMutableString string];
        [_answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *answerBtn = (UIButton *)obj;
            [answerString appendString:answerBtn.currentTitle];
        }];
    
    //判断答案是否正确
    Guessmodel *question = self.question[index];
    if ([question.answer isEqualToString:answerString]) {
        //如果正确,字体变绿、加金币、时隔1秒跳转下一题、标记当前题目的答题状态（已经答过）
        [self changeColor:[UIColor greenColor]];
        if (!question.isHind) {
            [self changeCoin:1000];
        }
        question.isFinish = YES;
        [self performSelector:@selector(nBtn) withObject:nil afterDelay:1];
        _tipBtn.enabled = NO;
        }else{
            //如果错误，字体变红
        [self changeColor:[UIColor redColor]];
        }
    }
}
- (void)changeColor:(UIColor *)color{
    [_answerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    UIButton * answerBtn = (UIButton *)obj;
        [answerBtn setTitleColor:color forState:UIControlStateNormal];
    }];
}
- (void)changeCoin:(NSInteger )num{
//取出当前金币数
    NSString *currentitle = _cornbtn.currentTitle;
    NSInteger result = [currentitle integerValue] + num;
    NSString *resulttitle = [NSString stringWithFormat:@"%ld",result];
    [_cornbtn setTitle:resulttitle forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
