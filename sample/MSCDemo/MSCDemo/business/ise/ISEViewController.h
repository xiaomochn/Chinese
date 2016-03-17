//
//  ISEViewController.h
//  MSCDemo_UI
//
//  Created by 张剑 on 15/1/15.
//
//

#import <UIKit/UIKit.h>
#import "TTSUIController.h"
@class ISEParams;//评测

@interface ISEViewController : TTSUIController

@property (nonatomic, strong) ISEParams *iseParams;
- (void)start:(NSString *) str;
- (void)onBtnCancel;
- (void)onBtnStop;
@end
