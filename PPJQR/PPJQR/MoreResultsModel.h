//
//  AnswerModel.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/12.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AnswerModel @end
@interface AnswerModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*type;
@property(nonatomic,strong)NSString <Optional>*text;

@end


@interface MoreResultsModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*rc;
@property(nonatomic,strong)NSString <Optional>*operation;
@property(nonatomic,strong)NSString <Optional>*service;
@property(nonatomic,strong)AnswerModel <Optional>*answer;
@property(nonatomic,strong)NSString <Optional>*text;

@end
