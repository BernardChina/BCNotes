//
//  FMDBHelper.h
//  notepassword
//
//  Created by 刘勇强 on 17/1/26.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBHelper : NSObject

+ (instancetype)sharedInstance;

-(void)addNote:(NSString *)sql;
//
-(void)deleteNote:(NSString *)sql;

-(NSArray *)searchNote:(NSString *)sql;

- (NSArray *)select:(NSString *)sql;

- (BOOL)isSSL;

@end
