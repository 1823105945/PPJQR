//
//  HomeViewController.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/2.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "HomeViewController.h"
#import "PPJQR.h"
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "PcmPlayer.h"
#import "TTSConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "Tools.h"
#import "MoreResultsModel.h"
#import "PlayModel.h"
#import "WeatherModel.h"
#import <FSAudioStream.h>
#import "HomeLeftView.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface HomeViewController ()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>{
    UIScrollView *homeScrollView;
    UITableView *homeTableView;
    AVAudioRecorder *_audioRecorder;
    HomeLeftView *homeLeftView;
      CBCentralManager *_bluetoothManager;
    BOOL _canShake;
    NSTimer *timeT;
    __weak IBOutlet UIButton *twoButton;
    __weak IBOutlet UIButton *threeButton;
    __weak IBOutlet UIButton *homeButton;
    __weak IBOutlet UIButton *fourButton;
}
@property(nonatomic,strong)NSString *returnType;
@property(nonatomic,strong)MoreResultsModel *moreResultsModel;
@property(nonatomic,strong)PlayModel *playModel;
@property(nonatomic,strong)WeatherModel *weatherModel;
//语音语义理解对象
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSString *uriPath;
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;
@property (nonatomic, assign) Status state;
@property (nonatomic, assign) SynthesizeType synType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *homeSegmentedContor;
@property (weak, nonatomic) IBOutlet UILabel *selectView;


@property (nonatomic, strong) FSAudioStream *audioStream;

@end

@implementation HomeViewController

-(void)leftUI{
    
    __weak typeof(self)SelfWeek=self;
    homeLeftView=[[[NSBundle mainBundle]loadNibNamed:@"HomeLeftView" owner:self options:nil]lastObject];
    [homeLeftView _initHomeLeftView];
    homeLeftView.HomeLeftClock=^(){
        [SelfWeek performSegueWithIdentifier:@"login" sender:nil];
    };
    homeLeftView.HomeLeftFootClock=^(NSInteger index){
        if (index==1000) {
            [SelfWeek performSegueWithIdentifier:@"login" sender:nil];
        }else{
            NSLog(@"退出账号");
        }
    };
    homeLeftView.LeftClockCell=^(NSInteger index){
        if (index==0) {
            [SelfWeek performSegueWithIdentifier:@"Explain" sender:nil];
        }else if(index==1){
            [SelfWeek performSegueWithIdentifier:@"Feedback" sender:nil];
        }
    };
    homeLeftView.hidden=YES;
    homeLeftView.frame=CGRectMake(0, 64, ViewSize.width, ViewSize.height-64);
    [self.view addSubview:homeLeftView];
}

-(void)_initbluetoothManager{
    _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //第一次打开或者每次蓝牙状态改变都会调用这个函数
    if(central.state==CBCentralManagerStatePoweredOn)
    {
        NSLog(@"蓝牙设备开着");
        _canShake=YES;
    }
    else
    {
        NSLog(@"蓝牙设备关着");
       
        _canShake=NO;
    }
}


//中文会话
- (IBAction)conversation:(id)sender {
    twoButton.selected=NO;
    threeButton.selected=NO;
    homeButton.selected=YES;
    fourButton.selected=NO;
    //设置为麦克风输入语音
    [_iFlySpeechUnderstander setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    bool ret = [_iFlySpeechUnderstander startListening];
    
    if (ret) {
        
        
//        [_onlineRecBtn setEnabled:NO];
//        [_cancelBtn setEnabled:YES];
//        [_stopBtn setEnabled:YES];
//        
//        [_textUnderBtn setEnabled:NO];
//        
//        self.isCanceled = NO;
        
        
    }
    else
    {
//        [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束
    }

    
   }


//英文会话
- (IBAction)enconversation:(id)sender {
    twoButton.selected=YES;
    threeButton.selected=NO;
    homeButton.selected=NO;
    fourButton.selected=NO;
    [IATConfig sharedInstance].language = [IFlySpeechConstant LANGUAGE_ENGLISH];
     [_iFlySpeechUnderstander setParameter:[IATConfig sharedInstance].language forKey:[IFlySpeechConstant LANGUAGE]];
}
//中译英
- (IBAction)cnEntranslation:(id)sender {
    twoButton.selected=NO;
    threeButton.selected=YES;
    homeButton.selected=NO;
    fourButton.selected=NO;
}
//英译中
- (IBAction)Encntranslation:(id)sender {
    twoButton.selected=NO;
    threeButton.selected=NO;
    homeButton.selected=NO;
    fourButton.selected=YES;
    
}
- (IBAction)homeClock:(id)sender {
    UISegmentedControl *segmentedControl=(UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex==0) {
        self.selectView.frame=CGRectMake(0, 227, ViewSize.width/2, 1);
        
    }else{
        self.selectView.frame=CGRectMake(ViewSize.width/2, 227, ViewSize.width/2, 1);
    }
    [homeScrollView setContentOffset:CGPointMake(ViewSize.width*segmentedControl.selectedSegmentIndex, 0) animated:YES];//.contentOffset=CGPointMake(ViewSize.width*segmentedControl.selectedSegmentIndex, 0);
}


/**
 语义理解服务结束回调（注：无论是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    
    NSString *text ;
//    if (self.isCanceled) {
//        text = @"语义理解取消";
//    }
    
    if (error.errorCode ==0 ) {
//        if (_result.length==0) {
//            text = @"无识别结果";
//        }
//        else
//        {
//            text = @"识别成功";
//        }
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    
    
    
}


/**
 语义理解结果回调
 result 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    __weak typeof(self)SelfWeek=self;
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results [0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSLog(@"听写结果：%@",result);
    [Tools ANSWER:result success:^(id responseObject, NSString *type) {
        SelfWeek.returnType=type;
        if ([responseObject isKindOfClass:[MoreResultsModel class]]) {
            SelfWeek.moreResultsModel=responseObject;
            [SelfWeek speechSynthesis:SelfWeek.moreResultsModel.answer.text];
            [SelfWeek dataSouse:@"weixin" Value:SelfWeek.moreResultsModel.text];
            [SelfWeek dataSouse:@"rhl" Value:SelfWeek.moreResultsModel.answer.text];
        }else if ([responseObject isKindOfClass:[PlayModel class]]){
            SelfWeek.playModel=responseObject;
            if (SelfWeek.playModel.data.result>0) {
               ResultModel *resultModel= [SelfWeek.playModel.data.result objectAtIndex:0];
                [SelfWeek startPlay:resultModel.downloadUrl];
                [SelfWeek dataSouse:@"weixin" Value:SelfWeek.playModel.text];
                [SelfWeek dataSouse:@"rhl" Value:resultModel.sourceName];
//                [SelfWeek speechSynthesis:resultModel.sourceName];

            }
            
        }else if ([responseObject isKindOfClass:[WeatherModel class]]){
            SelfWeek.weatherModel=responseObject;
            if (SelfWeek.weatherModel.data.result>0) {
                WeatherResultModel *WeatherResultModel= [SelfWeek.weatherModel.data.result objectAtIndex:0];
                [SelfWeek dataSouse:@"weixin" Value:SelfWeek.weatherModel.text];
                NSString *str=[NSString stringWithFormat:@"%@%@%@%@",WeatherResultModel.city,WeatherResultModel.weather,WeatherResultModel.tempRange,WeatherResultModel.wind];
                [SelfWeek dataSouse:@"rhl" Value:str];
                [SelfWeek speechSynthesis:str];
            }
            
//            SelfWeek
        }else{
            [SelfWeek speechSynthesis:@"抱歉不知道你在说什么"];
        }
    }];
//    [self hecheng];
}


// 播放网络音频按钮
- (void)startPlay:(NSString *)sender {
    if (!_audioStream) {
        [self playNetworkMusic:sender];
    }
    [_audioStream play];
    
}

// 播放网络音频
- (void)playNetworkMusic:(NSString *)url
{
    // 网络文件
    
    // 创建FSAudioStream对象
    _audioStream=[[FSAudioStream alloc]initWithUrl:[NSURL URLWithString:url]];
    _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
        NSLog(@"播放过程中发生错误，错误信息：%@",description);
    };
    __weak typeof(self) weakSelf = self;
    _audioStream.onCompletion=^(){
        NSLog(@"播放完成!");
//
        // 播放完移除对象，重新创建对象播放下一首
//        [weakSelf removeFromParentViewController];
        [weakSelf conversation:nil];
//        [self yanchi];
       
    };
    
    // 设置声音
    [_audioStream setVolume:1];
    
}

//语音合成
-(void)speechSynthesis:(NSString *)synthesis{
    _iFlySpeechSynthesizer.delegate = self;
    
    
    [_iFlySpeechSynthesizer startSpeaking:synthesis];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }

}

-(void)_init{
    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
}
/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    //语义理解单例
    if (_iFlySpeechUnderstander == nil) {
        _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    }
    
    _iFlySpeechUnderstander.delegate = self;
    
    if (_iFlySpeechUnderstander != nil) {
        IATConfig *instance = [IATConfig sharedInstance];

        //参数意义与IATViewController保持一致，详情可以参照其解释
        [_iFlySpeechUnderstander setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        [_iFlySpeechUnderstander setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        [_iFlySpeechUnderstander setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        [_iFlySpeechUnderstander setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            [_iFlySpeechUnderstander setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            [_iFlySpeechUnderstander setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechUnderstander setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        [_iFlySpeechUnderstander setParameter:instance.dot forKey:[IFlySpeechConstant ASR_SCH]];
    }
}

-(void)_initSpeechSynthesis{
    //     使用-(void)synthesize:(NSString *)text toUri:(NSString*)uri接口时， uri 需设置为保存音频的完整路径
    //     若uri设为nil,则默认的音频保存在library/cache下
    NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //uri合成路径设置
    _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
    //pcm播放器初始化
    _audioPlayer = [[PcmPlayer alloc] init];

}

/**
 开始播放回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakBegin
{

    if (_state  != Playing) {

    }
    _state = Playing;
}
/**
 缓冲进度回调
 
 progress 缓冲进度
 msg 附加信息
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}

/**
 播放进度回调
 
 progress 缓冲进度
 
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
    NSLog(@"speak progress %2d%%.", progress);
    NSLog(@"ttttttttt%d",progress);
    if (progress==100) {
        [self yanchi];
    }

}

-(void)yanchi{
    double delayInSeconds = 1.0;
    __weak typeof(self) bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself delayMethod]; });
}
    
-(void)delayMethod{
    NSLog(@"==========");
    [self conversation:nil];
}

/**
 合成结束（完成）回调
 
 对uri合成添加播放的功能
 ****/
- (void)onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s,error=%d",__func__,error.errorCode);
    
    if (error.errorCode != 0) {
//        [_popUpView showText:[NSString stringWithFormat:@"错误码:%d",error.errorCode]];
        return;
    }
    NSString *text ;
     if (error.errorCode == 0) {
        text = @"合成结束";
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    
    
    _state = NotStart;
    
//    if (_synType == UriType) {//Uri合成类型
//        
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if ([fm fileExistsAtPath:_uriPath]) {
//            [self playUriAudio];//播放合成的音频
//        }
//    }
}


#pragma mark - 设置合成参数
- (void)initSynthesizer
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    
    NSDictionary* languageDic=@{@"Guli":@"text_uighur", //维语
                                @"XiaoYun":@"text_vietnam",//越南语
                                @"Abha":@"text_hindi",//印地语
                                @"Gabriela":@"text_spanish",//西班牙语
                                @"Allabent":@"text_russian",//俄语
                                @"Mariane":@"text_french"};//法语
    
    NSString* textNameKey=[languageDic valueForKey:instance.vcnName];
    NSString* textSample=nil;
    
    if(textNameKey && [textNameKey length]>0){
        textSample=NSLocalizedStringFromTable(textNameKey, @"tts/tts", nil);
    }else{
        textSample=NSLocalizedStringFromTable(@"text_chinese", @"tts/tts", nil);
    }
    NSLog(@"%@",textSample);
//    [_textView setText:textSample];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initRecognizer];
    [self initSynthesizer];
}

-(void)dataSouse:(NSString *)key Value:(NSString *)value{
    NSDictionary *dict;
    if ([key isEqualToString:@"weixin"]) {
        dict= [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",value,@"content", nil];
    }else{
        dict= [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",value,@"content", nil];
    }
    
    [_resultArray addObject:dict];
    [homeTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self homeNaviUI];
    _resultArray=[[NSMutableArray alloc]init];
    homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initUI];
    [self leftUI];
    homeButton.selected=YES;
//    [self conversation:nil];
}

-(void)mulist{
    homeLeftView.hidden=NO;
}

-(void)initUI{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGBA(0, 0, 0,1),UITextAttributeTextColor,nil];
    [self.homeSegmentedContor setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:RGBA(0, 0, 0,1),UITextAttributeTextColor,nil];
    [self.homeSegmentedContor setTitleTextAttributes:dics forState:UIControlStateNormal];
    self.homeSegmentedContor.tintColor = [UIColor whiteColor];
    homeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 227, ViewSize.width, ViewSize.height-227-44)];
    homeScrollView.delegate=self;
    homeScrollView.backgroundColor=[UIColor redColor];
    homeScrollView.contentSize=CGSizeMake(ViewSize.width*2,0 );
    homeScrollView.pagingEnabled=YES;
    [self.view addSubview:homeScrollView];
    homeTableView=[[UITableView alloc]initWithFrame:CGRectMake(ViewSize.width, 0, ViewSize.width, homeScrollView.frame.size.height)];
    homeTableView.delegate=self;
    homeTableView.dataSource=self;
    [homeScrollView addSubview:homeTableView];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    self.homeSegmentedContor.selectedSegmentIndex=point.x/ViewSize.width;
    self.selectView.frame=CGRectMake(point.x/ViewSize.width*ViewSize.width/2, 227, ViewSize.width/2, 1);
}
//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    NSLog(@"%f,%f",size.width,size.height);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(ViewSize.width-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if(fromSelf)
        button.frame =CGRectMake(ViewSize.width-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        button.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%d''",logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    return button;
}

#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height+44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }
    
    NSDictionary *dict = [_resultArray objectAtIndex:indexPath.row];
    
    //创建头像
    UIImageView *photo ;
    if ([[dict objectForKey:@"name"]isEqualToString:@"rhl"]) {
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(ViewSize.width-60, 10, 50, 50)];
        [cell addSubview:photo];
        photo.image = [UIImage imageNamed:@"登录_07"];
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            [cell addSubview:[self yuyinView:1 from:YES withIndexRow:indexPath.row withPosition:65]];
            
            
        }else{
            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:YES withPosition:65]];
        }
        
    }else{
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [cell addSubview:photo];
        photo.image = [UIImage imageNamed:@"登录_03"];
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            [cell addSubview:[self yuyinView:1 from:NO withIndexRow:indexPath.row withPosition:65]];
        }else{
            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:NO withPosition:65]];
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
