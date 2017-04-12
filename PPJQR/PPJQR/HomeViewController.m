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

@interface HomeViewController ()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIScrollView *homeScrollView;
    UITableView *homeTableView;
    AVAudioRecorder *_audioRecorder;
    
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
//中文会话
- (IBAction)conversation:(id)sender {
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

}
//中译英
- (IBAction)cnEntranslation:(id)sender {
    
}
//英译中
- (IBAction)Encntranslation:(id)sender {
    
}
- (IBAction)homeClock:(id)sender {
    UISegmentedControl *segmentedControl=(UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex==0) {
        self.selectView.frame=CGRectMake(0, 0, ViewSize.width/2, 1);
    }else{
        self.selectView.frame=CGRectMake(ViewSize.width/2, 0, ViewSize.width/2, 1);
    }
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
        }else if ([responseObject isKindOfClass:[PlayModel class]]){
            SelfWeek.playModel=responseObject;
            if (SelfWeek.playModel.data.result>0) {
               ResultModel *resultModel= [SelfWeek.playModel.data.result objectAtIndex:0];
                [SelfWeek startPlay:resultModel.downloadUrl];
            }
            
        }else if ([responseObject isKindOfClass:[WeatherModel class]]){
            SelfWeek.weatherModel=responseObject;
        }else{
            
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
        // 播放完移除对象，重新创建对象播放下一首
        [weakSelf removeFromParentViewController];
       
    };
    
    // 设置声音
    [_audioStream setVolume:1];
    
}

//语音合成
-(void)speechSynthesis:(NSString *)synthesis{
    _iFlySpeechSynthesizer.delegate = self;
    
    
    [_iFlySpeechSynthesizer startSpeaking:@"爸爸妈妈说实诚不叫傻"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"微信团队欢迎你。很高兴你开启了微信生活，期待能为你和朋友们带来愉快的沟通体检。",@"content", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"hello",@"content", nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"0",@"content", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"谢谢反馈，已收录。",@"content", nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"0",@"content", nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"谢谢反馈，已收录。",@"content", nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",@"大数据测试，长数据测试，大数据测试，长数据测试，大数据测试，长数据测试，大数据测试，长数据测试，大数据测试，长数据测试，大数据测试，长数据测试。",@"content", nil];
    
    _resultArray = [NSMutableArray arrayWithObjects:dict,dict1,dict2,dict3,dict4,dict5,dict6, nil];
    [self initUI];
}

-(void)initUI{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGBA(0, 0, 0,1),UITextAttributeTextColor,nil];
    [self.homeSegmentedContor setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:RGBA(0, 0, 0,1),UITextAttributeTextColor,nil];
    [self.homeSegmentedContor setTitleTextAttributes:dics forState:UIControlStateNormal];
    self.homeSegmentedContor.tintColor = [UIColor whiteColor];
    homeScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, ViewSize.width, ViewSize.height-244)];
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
    self.selectView.frame=CGRectMake(point.x/ViewSize.width*ViewSize.width/2, 199, ViewSize.width/2, 1);
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
        photo.image = [UIImage imageNamed:@"photo1"];
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            [cell addSubview:[self yuyinView:1 from:YES withIndexRow:indexPath.row withPosition:65]];
            
            
        }else{
            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:YES withPosition:65]];
        }
        
    }else{
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [cell addSubview:photo];
        photo.image = [UIImage imageNamed:@"photo"];
        
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
