//
//  FMDBHelper.m
//  notepassword
//
//  Created by 刘勇强 on 17/1/26.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import "FMDBHelper.h"
#import "NoteModel.h"
#import <FMDB/FMDatabase.h>

@interface FMDBHelper()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation FMDBHelper

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FMDBHelper *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *path = [document stringByAppendingPathComponent:@"notepassword.db"];
        
        
        _db = [FMDatabase databaseWithPath:path];
        
        if (![_db open]) {
            _db = nil;
        }
        
        [_db executeUpdate:@"CREATE TABLE 'note_text' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'notes' TEXT, 'updateTime' TEXT)"];
        [_db executeUpdate:@"CREATE TABLE 'note_login' ('pwd' TEXT)"];
    }
    return self;
}

- (void)addNote:(NSString *)sql {
    if ([self.db open]) {
       [self.db executeUpdate:sql];
    }
    
    [self.db close];
}

- (NSArray *)searchNote:(NSString *)sql {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self.db open]) {
        FMResultSet * rs = [self.db executeQuery:sql];
        while ([rs next]) {
            NoteModel *model = [[NoteModel alloc] init];
            model.noteId = [rs intForColumn:@"id"];
            model.notes = [rs stringForColumn:@"notes"];
            model.updateTime = [rs stringForColumn:@"updateTime"];
            [array addObject:model];
        }
    }
    [self.db close];
    return array;
}

- (void)deleteNote:(NSString *)sql {
    if ([self.db open]) {
        [self.db executeUpdate:sql];
    }
    [self.db close];
}

- (NSArray *)select:(NSString *)sql {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]) {
            [array addObject:[rs stringForColumn:@"pwd"]];
        }
    }
    [self.db close];
    return array;
}

- (BOOL)isSSL {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sql = @"select * from note_login";
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:sql];
        while ([rs next]) {
            [array addObject:[rs stringForColumn:@"pwd"]];
        }
    }
    [self.db close];
    return array.count > 0;
}

@end
