//
//  FCHomeViewController.m
//  FastCounter
//
//  Created by LiuYong on 2018/4/12.
//  Copyright © 2018年 LiuYong. All rights reserved.


#import "FCCounterViewController.h"
#import "FCCounterGameViewController.h"

@interface FCCounterViewController ()

@property (strong, nonatomic) IBOutlet UILabel *bestRecordLabel;


@end

@implementation FCCounterViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    [self setRecordLabelText];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}



//游戏开始
- (IBAction)startGameClick:(UIButton *)sender {
    FCCounterGameViewController*gVC=[[FCCounterGameViewController alloc]init];
    [self pushToNextViewController:gVC];
}

-(void)setRecordLabelText{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"counter_bestRecord"]) {
        self.bestRecordLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"counter_bestRecord"];
    }else{
        self.bestRecordLabel.text=@"0";
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
