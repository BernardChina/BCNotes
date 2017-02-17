//
//  AddNoteViewController.m
//  notepassword
//
//  Created by 刘勇强 on 17/1/26.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import "addNoteViewController.h"
#import "FMDBHelper.h"
#import <Masonry/Masonry.h>

@interface AddNoteViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTextView];
    
    [self.textView becomeFirstResponder];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(addNoteDone:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)setUpTextView {
    self.textView = [[UITextView alloc] init];
    [self.textView setFont:[UIFont systemFontOfSize:12]];
    
    if (self.noteModel) {
        self.textView.text = self.noteModel.notes;
    }
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
}

- (void)addNoteDone:(id)object {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return;
    }
    
    NSDateFormatter *LocalDateFormatter = [[NSDateFormatter alloc] init];
    LocalDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [LocalDateFormatter stringFromDate:[NSDate date]];
    
    NSString *sql = [NSString stringWithFormat:@"insert into note_text (notes,updateTime) values ('%@', '%@')",self.textView.text, dateString];
    
    if (self.noteModel) {
        sql = [NSString stringWithFormat:@"update note_text set notes = '%@', updateTime = '%@' where id = %d",self.textView.text,dateString,self.noteModel.noteId];
    }
    
    [[FMDBHelper sharedInstance] addNote:sql];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"AddNoteViewController dealloc");
}

@end
