//
//  CountdownLabel.h
//  CountdownLabelDemo
//
//  Created by  on 16/6/8.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CountDownType) {
    CountDownNumber = 0,
    CountDownString
};

@class CountdownLabel;

// delegate
@protocol CountdownLabelDelegate <NSObject>

@optional
//** 倒计时完成时调用 */
- (void)countdownSuccess:(CountdownLabel *)label;

//** 倒计时开始时调用 */
- (void)countdownBegin:(CountdownLabel *)label;
@end

//** 倒计时完成时调的block */
typedef void(^CountdownSuccessBlock)(CountdownLabel *label);
//** 倒计时开始时调的block */
typedef void(^CountdownBeginBlock)(CountdownLabel *label);

@interface CountdownLabel : UILabel

//** delegate */
@property (nonatomic, weak) id<CountdownLabelDelegate> delegate;
//** 隐藏 */
+ (void)hidden;
//** 全是默认值的play方法 */
+ (instancetype)play;

//** number : 倒计时开始数字 */
+ (instancetype)playWithNumber:(NSInteger)number;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符 */
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle;
//** number : 倒计时开始数字；success : 倒计时完成回调 */
+ (instancetype)playWithNumber:(NSInteger)number success:(CountdownSuccessBlock)success;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符；success : 倒计时完成回调； */
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle success:(CountdownSuccessBlock)success;
//** number : 倒计时开始数字；endTitle : 倒计时结束时显示的字符；begin : 倒计时开始回调；success : 倒计时完成回调；*/
+ (instancetype)playWithNumber:(NSInteger)number endTitle:(NSString *)endTitle begin:(CountdownBeginBlock)begin success:(CountdownSuccessBlock)success;

//** 绑定代理 */
+ (void)addDelegate:(id<CountdownLabelDelegate>)delegate;
//** 倒计时完成时的block监听 */
+ (void)addCountdownSuccessBlock:(CountdownSuccessBlock)success;
//** 倒计时开始时的block监听 */
+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin;
//** 倒计时开始时和结束时的block监听 */
+ (void)addCountdownBeginBlock:(CountdownBeginBlock)begin successBlock:(CountdownSuccessBlock)success;

@end
