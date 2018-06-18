//
//  FCAlertView.h
//  FastCounter
//
//  Created by LiuYong on 2018/4/12.
//  Copyright © 2018年 LiuYong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBackBlock)(void);

@interface FCAlertView : UIViewController
@property(nonatomic,copy)callBackBlock callBack;
@end
