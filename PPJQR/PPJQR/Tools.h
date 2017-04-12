//
//  Tools.h
//  PPJQR
//
//  Created by liu_yakai on 17/4/12.
//  Copyright © 2017年 liu_yakai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject


+(NSDictionary *)jsontodic:(NSString *)str;

+(void)ANSWER:(NSString *)answerStr success:(void (^)(id responseObject,NSString *type))success;
@end
