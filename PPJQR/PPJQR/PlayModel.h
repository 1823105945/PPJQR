//
//  PlayModel.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/12.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ResultModel @end
@interface ResultModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*singer;
@property(nonatomic,strong)NSString <Optional>*sourceName;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*downloadUrl;
@end

@protocol DataModel @end
@interface DataModel : JSONModel
@property(nonatomic,strong)NSArray <Optional,ResultModel>*result;

@end

@interface PlayModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*rc;
@property(nonatomic,strong)NSString <Optional>*operation;
@property(nonatomic,strong)NSString <Optional>*service;
@property(nonatomic,strong)DataModel <Optional>*data;
@property(nonatomic,strong)NSString <Optional>*text;
@end
