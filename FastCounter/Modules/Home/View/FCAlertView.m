//
//  FCAlertView.m
//  FastCounter
//
//  Created by LiuYong on 2018/4/12.
//  Copyright © 2018年 LiuYong. All rights reserved.
//

#import "FCAlertView.h"

@interface FCAlertView ()

@end

@implementation FCAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}
- (IBAction)Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.callBack) {
        self.callBack();
    }
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.callBack) {
        self.callBack();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
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
