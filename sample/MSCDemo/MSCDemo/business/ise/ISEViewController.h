//
//  ISEViewController.h
//  MSCDemo_UI
//
//  Created by 张剑 on 15/1/15.
//
//

#import <UIKit/UIKit.h>

@class ISEParams;//评测

@interface ISEViewController : UIViewController

@property (nonatomic, strong) ISEParams *iseParams;
- (void)start:(NSString *) str;
@end
