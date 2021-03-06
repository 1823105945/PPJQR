//
//  FeedbackViewController.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/20.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"
#import "BaseView.h"
#import "FeedBackView.h"

@interface FeedbackViewController (){
    FeedBackView *feed;
}
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *placeholderTextView;
@property (weak, nonatomic) IBOutlet UITextField *userName;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightUI];
    [self FeedbackUI];
    
}
- (IBAction)Clock:(id)sender {
    [[BaseView baseShar]_initPop:feed Type:1];
}

-(void)FeedbackUI{
    feed=[[[NSBundle mainBundle]loadNibNamed:@"FeedBackView" owner:self options:nil]lastObject];
    [feed _init];
}

-(void)Submit{
    if (feed.title.length==0) {
        
    }
    NSLog(@"提交");
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
