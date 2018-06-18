//
//  CountdownLabel.m
//  CountdownLabelDemo
//
//  Created by  on 16/6/8.
//

#import "CountdownLabel.h"
#import "AppDelegate.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define AppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define TextColor [UIColor redColor]
#define FontSize ScreenWidth/414
#define Font(size) [UIFont boldSystemFontOfSize:(size * FontSize)]
#define SetWidth(frame, w) frame = CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height)
#define StringWidth(string, font) [label.endTitle sizeWithAttributes:@{NSFontAttributeName : font}].width

@interface CountdownLabel ()
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *endTitle;
@property (nonatomic, copy) CountdownSuccessBlock countdownSuccessBlock;
@property (nonatomic, copy) CountdownBeginBlock countdownBeginBlock;

@end

@implementation CountdownLabel

static BOOL isAnimationing;

+ (instancetype)share {
    static CountdownLabel *label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[CountdownLabel alloc] init];
        isAnimationing = NO;
    });
    return label;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isAnimationing = NO;
    }
    return self;
}

+ (void)hidden {
    isAnimationing = NO;
    // 复原label状态，这句话必须写，不然又问题
    [CountdownLabel share].transform = CGAffineTransformIdentity;
    [CountdownLabel share].hidden = YES;
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success {
    // isAnimationing 用来判断目前是否在动画
    if (isAnimationing) return nil;
    CountdownLabel *label = [CountdownLabel share];
    label.hidden = NO;
    // 给全局属性赋值
    // 默认三秒
    label.number = 3;
    if (number && number > 0) label.number = number;
    if (endTitle) label.endTitle = endTitle;
    if (success) label.countdownSuccessBlock = success;
    if (begin) label.countdownBeginBlock = begin;
    
    [self setupLabelBase:label];
    // 动画倒计时部分
    [self scaleActionWithBeginBlock:begin andSuccessBlock:success label:label];
    return label;
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle success:(CountdownSuccessBlock)success{
    return [self playWithNumber:number endTitle:endTitle begin:[CountdownLabel share].countdownBeginBlock success:success];
}

// label的基本属性
+ (void)setupLabelBase:(CountdownLabel *)label {
    label.frame = (CGRect){0, 0, 50, ScreenWidth};
    label.transform = CGAffineTransformScale(label.transform, 10, 10);
    label.alpha = 0;
    label.text = [NSString stringWithFormat:@"%zd", label.number];
    label.textColor = MainColor;
    label.font = Font(20.0f);
    [[label getCurrentView] addSubview:label];
    label.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    label.textAlignment = NSTextAlignmentCenter;
}

// 动画倒计时部分
+ (void)scaleActionWithBeginBlock:(CountdownBeginBlock)begin andSuccessBlock:(CountdownSuccessBlock)success label:(CountdownLabel *)label {
    if (!isAnimationing) { // 如果不在动画才走开始的代理和block
        if (begin) begin(label);
        if ([label.delegate respondsToSelector:@selector(countdownBegin:)]) [label.delegate countdownBegin:label];
    }
    // 这个判断用来表示有没有结束语
    if (label.number >= (label.endTitle ? 0 : 1)) {
        isAnimationing = YES;
        label.text = label.number == 0 ? label.endTitle : [NSString stringWithFormat:@"%zd", label.number];
        [UIView animateWithDuration:1 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                label.number--;
                label.alpha = 0;
                label.transform = CGAffineTransformScale(label.transform, 10, 10);
                [self scaleActionWithBeginBlock:begin andSuccessBlock:success label:label];
            }
        }];
    } else {
        // 调用倒计时完成的代理和block
        if ([label.delegate respondsToSelector:@selector(countdownSuccess:)]) [label.delegate countdownSuccess:label];

        if (success) success(label);
        [self hidden];
    }
}

// 拿到当前显示的控制器的View。不建议直接放到window上，这样的话，如果倒计时不结束视图就跳转，倒计时不会停止移除
- (UIView *)getCurrentView {
    return [self getVisibleViewControllerFrom:(UIViewController *)AppDelegate.window.rootViewController].view;
}

/// 这个方法是拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到，相信很多项目会用到。拿去不谢！
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

#pragma mark - play methods
+ (instancetype)play {
    return [self playWithNumber:0];
}

+ (instancetype)playWithNumber:(NSInteger)number {
    return [self playWithNumber:number endTitle:[CountdownLabel share].endTitle];
}

+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle {
    return [self playWithNumber:number endTitle:endTitle success:[CountdownLabel share].countdownSuccessBlock];
}

+ (instancetype)playWithNumber:(NSInteger)number success:(CountdownSuccessBlock)success {
    return [self playWithNumber:number endTitle:[CountdownLabel share].endTitle success:success];
}

#pragma mark - add block
+ (void)addCountdownSuccessBlock:(CountdownSuccessBlock)success {
    [CountdownLabel share].countdownSuccessBlock = success;
}

+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin {
    [CountdownLabel share].countdownBeginBlock = begin;
}

+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin successBlock:(CountdownSuccessBlock)success {
    [CountdownLabel share].countdownSuccessBlock = success;
    [CountdownLabel share].countdownBeginBlock = begin;
}

#pragma mark - add delegate
+ (void)addDelegate:(id<CountdownLabelDelegate>)delegate {
    [CountdownLabel share].delegate = delegate;
}

@end
