//
//  FCGameViewController.m
//  FastCounter
//
//  Created by LiuYong on 2018/4/12.
//  Copyright © 2018年 LiuYong. All rights reserved.
//

#import "FCCounterGameViewController.h"
#import "FCAlertView.h"

@interface FCCounterGameViewController ()

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *operateLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultsLabel;
@property(nonatomic,strong)NSArray*operateArr;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,assign)NSTimer *timer;
@property(nonatomic,strong)FCAlertView*alertView;


@end

@implementation FCCounterGameViewController

-(FCAlertView *)alertView{
    typeof(self) __weak weakSelf = self;
    if (!_alertView) {
        _alertView=[[FCAlertView alloc]init];
        _alertView.callBack = ^{
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"counter_bestRecord"]) {
                if (self.number>[[[NSUserDefaults standardUserDefaults]objectForKey:@"counter_bestRecord"] integerValue]) {
                    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",weakSelf.number-1] forKey:@"counter_bestRecord"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",weakSelf.number-1] forKey:@"counter_bestRecord"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [weakSelf.navigationController popViewControllerAnimated:NO];
        };
    }
    return _alertView;
}

-(NSArray *)operateArr{
    if (!_operateArr) {
        _operateArr=@[@"+",@"-"];
//        _operateArr=@[@"+",@"-",@"x"];
    }
    return _operateArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"加减大师";
    self.number=1;
    [self random];
    [self addTimer];
    
}

-(void)addTimer{

    self.progressView.progress=1.0f;
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(progressChanged:)
                                               userInfo:nil
                                                repeats:YES];
}

-(void)progressChanged:(UIProgressView*)sender{
    self.progressView.progress-=0.34;
    if (self.progressView.progress==0) {
        [self.timer invalidate];
        self.timer = nil;
        [self presentViewController:self.alertView animated:YES completion:nil];
    }
}

/*随机生成数字*/
-(void)random{
    
    NSInteger index =arc4random() % 2;
    self.operateLabel.text=self.operateArr[index];
    self.numLabel.text=[NSString stringWithFormat:@"第%ld题",(long)self.number];
    NSInteger firstNumber=0;
    NSInteger seconNumber=0;
    /*四个等级*/
    
    //1.两个1-10以内的数相加、减<10
    //2.两个1-15以内的数相加、减<20
    //3.两个1-20以内的数相加、减<30
    //4.两个1-35以内的数相加、减<35
    //5.两个1-40以内的数相加、减<40
    if (self.number<10) {
        firstNumber=(arc4random() % 9) + 1;
        seconNumber=(arc4random() % 9) + 1;
    }else if (self.number<20){
        firstNumber=(arc4random() % 20) + 1;
        seconNumber=(arc4random() % 20) + 1;
    }else if (self.number<30){
        firstNumber=(arc4random() % 30) + 1;
        seconNumber=(arc4random() % 30) + 1;
    }else if (self.number<35){
        firstNumber=(arc4random() % 35) + 1;
        seconNumber=(arc4random() % 35) + 1;
    }else{
        firstNumber=(arc4random() % 40) + 1;
        seconNumber=(arc4random() % 40) + 1;
    }
    self.firstLabel.text=[NSString stringWithFormat:@"%ld",(long)firstNumber];
    self.secondLabel.text=[NSString stringWithFormat:@"%ld",(long)seconNumber];
    
    if ((self.number%3==(arc4random()%9+1)%2)) {
        //生成正确的答案
    self.resultsLabel.text=[self countNumberWithFirstNum:self.firstLabel.text SecondNum:self.secondLabel.text AndOperate:self.operateArr[index]];
    }else{
        //生成错误的答案
        if (self.number<10) {
            self.resultsLabel.text=[NSString stringWithFormat:@"%u",(arc4random()%9)+1];
        }else if (self.number<20){
            self.resultsLabel.text=[NSString stringWithFormat:@"%u",(arc4random()%20)+1];
        }else if (self.number<30){
            self.resultsLabel.text=[NSString stringWithFormat:@"%u",(arc4random()%30)+1];
        }else if (self.number<35){
            self.resultsLabel.text=[NSString stringWithFormat:@"%u",(arc4random()%40)+1];
        }else{
            self.resultsLabel.text=[NSString stringWithFormat:@"%u",(arc4random()%60)+1];
        }
    }
}

//点击事件的触发
- (IBAction)Click:(UIButton *)sender {
    
    if (sender.tag==99) {
        //对的按钮
        if ([[self countNumberWithFirstNum:self.firstLabel.text SecondNum:self.secondLabel.text AndOperate:self.operateLabel.text] isEqualToString:self.resultsLabel.text]) {
            self.number++;
            [self activateTimer];
        }else{
            [self.timer invalidate];
            self.timer = nil;
            [self presentViewController:self.alertView animated:YES completion:nil];
        }
    }else{
        //错的按钮
        if (![[self countNumberWithFirstNum:self.firstLabel.text SecondNum:self.secondLabel.text AndOperate:self.operateLabel.text] isEqualToString:self.resultsLabel.text]) {
            self.number++;
            [self activateTimer];
        }else{
            [self.timer invalidate];
            self.timer = nil;
            [self presentViewController:self.alertView animated:YES completion:nil];

        }
    }
}

-(NSString*)countNumberWithFirstNum:(NSString*)firstNum SecondNum:(NSString*)secondNum AndOperate:(NSString*)operate {
    NSInteger results=0;
    if ([operate isEqualToString:@"+"]) {
        results=[firstNum integerValue]+[secondNum integerValue];
    }else if ([operate isEqualToString:@"-"]){
        results=[firstNum integerValue]-[secondNum integerValue];
    }else if ([operate isEqualToString:@"x"]){
        results=[firstNum integerValue]*[secondNum integerValue];
    }else{
        results=[firstNum integerValue]/[secondNum integerValue];
    }
    return [NSString stringWithFormat:@"%ld",(long)results];
}

-(void)activateTimer{
    if ([self.timer isValid]==YES) {
        [self random];
        [self.timer invalidate];
        self.timer = nil;
        [self addTimer];
    }else{
        NSLog(@"时间到了");
        [self presentViewController:self.alertView animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
