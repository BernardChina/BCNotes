//
//  NoteModel.h
//  notepassword
//
//  Created by 刘勇强 on 17/1/26.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, assign) int noteId;

@property (nonatomic, strong) NSString *notes;

@property (nonatomic, strong) NSString *updateTime;

@end
