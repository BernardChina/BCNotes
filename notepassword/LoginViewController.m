//
//  LoginViewController.m
//  notepassword
//
//  Created by 刘勇强 on 17/1/28.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "FMDBHelper.h"

#import <Masonry/Masonry.h>

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x128B35);
    
    [self setUpTextField];
    [self setUpBackButton];
    [self setUpTitleLabel];
    [self setUpNextButton];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setUpTextField {
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.textField];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(44);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(view).offset(0);
        make.left.equalTo(view).offset(12);
    }];
}

- (void)setUpBackButton {
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(22);
    }];
}

- (void)setUpTitleLabel {
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
    }];
}

- (void)setUpNextButton {
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.textField.mas_bottom).offset(60);
        make.height.mas_equalTo(44);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"加密";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.cornerRadius = 5;
        _textField.placeholder = @"密码";
        _textField.backgroundColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.backgroundColor = [UIColor whiteColor];
        [_nextButton setTitleColor:UIColorFromRGB(0x128B35) forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    return _nextButton;
}

- (void)backAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextAction:(UIButton *)button {
    if ([[FMDBHelper sharedInstance] isSSL]) {
        NSString *sqld = [NSString stringWithFormat:@"select * from note_login where pwd = '%@'",self.textField.text];
        NSArray *array = [[FMDBHelper sharedInstance] select:sqld];
        
        if (array.count > 0) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notepassword_islogined"];
//            MainViewController *controller = [[MainViewController alloc] init];
//            [self.navigationController pushViewController:controller animated:YES];
        } else {
            NSLog(@"密码错误");
        }
        return;
    }
    
    if ([self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"insert into note_login (pwd) values ('%@')",self.textField.text];
    [[FMDBHelper sharedInstance] addNote:sql];
}

- (void)setIsLogined:(BOOL)isLogined {
    self.backButton.hidden = isLogined;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
