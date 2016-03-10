//
//  ISEUIViewController.m
//  MSCDemo
//
//  Created by wangdan on 15/5/21.
//
//

#import "ISEUIViewController.h"

#import "ISESettingViewController.h"
#import "PopupView.h"
#import "ISEConfig.h"
//#import "ISEParams.h"
#import "IFlyMSC/IFlyMSC.h"

#import "ISEResult.h"
#import "ISEResultXmlParser.h"
#import "Definition.h"
#import "ISEConfig.h"


#define INDICATOR_BTN       @"请点击“开始评测”按钮";
#define INDICATOR_READ      @"请朗读以上内容";
#define INDICATOR_WAIRING   @"停止评测，结果等待中...";

@interface ISEUIViewController ()<ISEResultXmlParserDelegate,IFlySpeechEvaluatorDelegate>

@end

@implementation ISEUIViewController

#pragma mark - 视图生命周期

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.speechEveluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [self InitEvaluater];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.speechEveluator cancel];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //键盘工具栏
    UIBarButtonItem *spaceBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    UIBarButtonItem *hideBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onKeyBoardDown:)];
    [hideBtnItem setTintColor:[UIColor whiteColor]];
    UIToolbar *keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
    NSArray *array = [NSArray arrayWithObjects:spaceBtnItem, hideBtnItem, nil];
    [keyboardToolbar setItems:array];
    _srcTextView.inputAccessoryView = keyboardToolbar;
    _srcTextView.textAlignment = IFLY_ALIGN_LEFT;
    
    _srcTextView.text = @"请问你来自哪里，要去何方，你知道谁是这个世界上最帅的帅哥么";
    
    
    _srcTextView.inputAccessoryView = keyboardToolbar;
    _srcTextView.layer.borderWidth = 0.5f;
    _srcTextView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [_srcTextView.layer setCornerRadius:7.0f];
    

 
}



#pragma mark - 事件响应函数


- (IBAction)starEBtnHandler:(id)sender {
    [self.speechEveluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.speechEveluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.speechEveluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    
    
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSLog(@"text encoding:%@",[self.speechEveluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
    NSLog(@"language:%@",[self.speechEveluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
    
    BOOL isUTF8=[[self.speechEveluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
    BOOL isZhCN=[[self.speechEveluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:@"zh_cn"];
    
    BOOL needAddTextBom=isUTF8&&isZhCN;
    NSMutableData *buffer = nil;
    if(needAddTextBom){
        if(self.srcTextView.text && [self.srcTextView.text length]>0){
            Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
            buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
            [buffer appendData:[self.srcTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
        }
    }else{
        buffer= [NSMutableData dataWithData:[self.srcTextView.text dataUsingEncoding:encoding]];
        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
    }
  
    self.resultText=@"";
    [self.speechEveluator startListening:buffer params:nil];
    self.isSessionResultAppear=NO;
    self.isSessionEnd=NO;
    self.startEvelutateBtn.enabled=NO;
    
}



- (IBAction)stopEBtnHandler:(id)sender {
    if(!self.isSessionResultAppear &&  !self.isSessionEnd){
        self.resultText=@"";
    }
    
    [self.speechEveluator stopListening];

    [self.srcTextView resignFirstResponder];
    self.startEvelutateBtn.enabled=YES;
    
}


- (IBAction)cancelEBtnHandler:(id)sender {
    [self.speechEveluator cancel];
    [self.srcTextView resignFirstResponder];
    [self.popupView removeFromSuperview];
    self.resultText=@"";
    self.startEvelutateBtn.enabled=YES;
    
}


- (IBAction)resultParserBtnHandler:(id)sender {
    
    ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
    parser.delegate=self;
    [parser parserXml:self.resultText];
    
}


-(void)resetBtnSatus:(IFlySpeechError *)errorCode{
    
    if(errorCode && errorCode.errorCode!=0){
        self.isSessionResultAppear=NO;
        self.isSessionEnd=YES;
    
        self.resultText=@"";
    }else{
        self.isSessionResultAppear=YES;
        self.isSessionEnd=YES;
    }
    self.startEvelutateBtn.enabled=YES;
}



#pragma mark - 评测结果回调IFlySpeechEvaluatorDelegate
/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    //    NSLog(@"volume:%d",volume);
    [self.popupView setText:[NSString stringWithFormat:@"音量：%d",volume]];
    [self.view addSubview:self.popupView];
}

/*!
 *  开始录音回调
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void)onBeginOfSpeech {
    
}

/*!
 *  停止录音回调
 *    当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。
 *  如果发生错误则回调onError:函数
 */
- (void)onEndOfSpeech {
    
}

/*!
 *  正在取消
 */
- (void)onCancel {
    
}

/*!
 *  评测结果回调
 *    在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.
 *  当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用
 *  `cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函
 *  数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onError:(IFlySpeechError *)errorCode {
    if(errorCode && errorCode.errorCode!=0){
        [self.popupView showText:[NSString stringWithFormat:@"错误码：%d %@",[errorCode errorCode],[errorCode errorDesc]]];
        [self.view addSubview:self.popupView];
        
    }
    
    [self performSelectorOnMainThread:@selector(resetBtnSatus:) withObject:errorCode waitUntilDone:NO];
    
}

/*!
 *  评测结果回调
 *   在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast{
    if (results) {
        NSString *showText = @"";
        
        const char* chResult=[results bytes];
        
        BOOL isUTF8=[[self.speechEveluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        NSString* strResults=nil;
        if(isUTF8){
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"result encoding: gb2312");
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        if(strResults){
            showText = [showText stringByAppendingString:strResults];
        }
        
        self.resultText=showText;
        
        self.isSessionResultAppear=YES;
        self.isSessionEnd=YES;
        if(isLast){
            [self.popupView setText:@"评测结束"];
            [self.view addSubview:self.popupView];
        }
        
    }
    else{
        if(isLast){
            [self.popupView setText:@"你好像没有说话哦"];
            [self.view addSubview:self.popupView];
        }
        self.isSessionEnd=YES;
    }
    self.startEvelutateBtn.enabled=YES;
}

#pragma mark - xml 解析结果回调ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 初始化评测器件

-(void)InitEvaluater {
    
    if (_speechEveluator == nil) {
        _speechEveluator = [IFlySpeechEvaluator sharedInstance];
    }
    _speechEveluator.delegate = self;
    
    ISEConfig *instance = [ISEConfig sharedInstance];
    
    [_speechEveluator setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
    [_speechEveluator setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
    [_speechEveluator setParameter:instance.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [_speechEveluator setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
    [_speechEveluator setParameter:instance.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [_speechEveluator setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    [_speechEveluator setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
//    if ([self.iseParams.language isEqualToString:KCLanguageZHCN]) {
//        if ([self.iseParams.category isEqualToString:KCCategorySyllable]) {
//            self.textView.text = LocalizedEvaString(KCTextCNSyllable, nil);
//        }
//        else if ([self.iseParams.category isEqualToString:KCCategoryWord]) {
//            self.textView.text = LocalizedEvaString(KCTextCNWord, nil);
//        }
//        else {
//            self.textView.text = LocalizedEvaString(KCTextCNSentence, nil);
//        }
//    }
//    else {
//        if ([self.iseParams.category isEqualToString:KCCategoryWord]) {
//            self.textView.text = LocalizedEvaString(KCTextENWord, nil);
//        }
//        else {
//            self.textView.text = LocalizedEvaString(KCTextENSentence, nil);
//        }
//        self.isValidInput=YES;
//        
//    }
    
    
}

@end
