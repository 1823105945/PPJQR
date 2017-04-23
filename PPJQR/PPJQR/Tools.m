//
//  Tools.m
//  PPJQR
//
//  Created by liu_yakai on 17/4/12.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import "Tools.h"
#import "MoreResultsModel.h"
#import "PlayModel.h"
#import "WeatherModel.h"
#import "BaseView.h"
#import "PPJQR.h"

@implementation Tools

+(NSDictionary *)jsontodic:(NSString *)str{
    NSError *error;
    NSString *requestTmp = [NSString stringWithString: str];
    
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    return  [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
}

+(void)ANSWER:(NSString *)answerStr success:(void (^)(id responseObject,NSString *type))success{
    NSDictionary *dic=[Tools jsontodic:answerStr];
    NSError *error;
    if ([[dic valueForKey:@"service"] isEqualToString:OPENQA]||[[dic valueForKey:@"service" ] isEqualToString: BAIKE]) {
        MoreResultsModel *moreResultsModel=[[MoreResultsModel alloc]initWithDictionary:dic error:&error];
        if (error) {
            [BaseView _init:@"请检查网络连接"];
        }else{
            success(moreResultsModel,OPENQA);
        }
        
    }else if ([[dic valueForKey:@"service"] isEqualToString:PLAYST]){
        PlayModel *moreResultsModel=[[PlayModel alloc]initWithDictionary:dic error:&error];
        if (error) {
            [BaseView _init:@"请检查网络连接"];
        }else{
            success(moreResultsModel,PLAYST);
        }
        
    }else if ([[dic valueForKey:@"service"] isEqualToString:WEATHER]){
        WeatherModel *moreResultsModel=[[WeatherModel alloc]initWithDictionary:dic error:&error];
        if (error) {
            [BaseView _init:@"请检查网络连接"];
        }else{
            success(moreResultsModel,WEATHER);
        }
        
    }
    
}

+(NSString *)strPec:(NSArray *)rect{
    return [rect componentsJoinedByString:@","];
}


@end
