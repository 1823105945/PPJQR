//
//  WeatherModel.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/12.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol WeatherResultModel @end
@interface WeatherResultModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*airQuality;
@property(nonatomic,strong)NSString <Optional>*sourceName;
@property(nonatomic,strong)NSString <Optional>*date;
@property(nonatomic,strong)NSString <Optional>*lastUpdateTime;
@property(nonatomic,strong)NSString <Optional>*dateLong;
@property(nonatomic,strong)NSString <Optional>*pm25;
@property(nonatomic,strong)NSString <Optional>*city;
@property(nonatomic,strong)NSString <Optional>*humidity;
@property(nonatomic,strong)NSString <Optional>*windLevel;
@property(nonatomic,strong)NSString <Optional>*weather;
@property(nonatomic,strong)NSString <Optional>*tempRange;
@property(nonatomic,strong)NSString <Optional>*wind;

@end
@interface WeatherDataModel : JSONModel
@property(nonatomic,strong)NSArray <Optional,WeatherResultModel>*result;

@end
@interface WeatherModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*rc;
@property(nonatomic,strong)NSString <Optional>*operation;
@property(nonatomic,strong)NSString <Optional>*service;
@property(nonatomic,strong)WeatherDataModel <Optional>*data;
@property(nonatomic,strong)NSString <Optional>*text;
@end
