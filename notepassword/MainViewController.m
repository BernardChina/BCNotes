//
//  MainViewController.m
//  notepassword
//
//  Created by 刘勇强 on 17/1/26.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import "MainViewController.h"
#import "AddNoteViewController.h"
#import "FMDBHelper.h"
#import "NoteModel.h"
#import "MainTableViewCell.h"
#import "LoginViewController.h"

#import <Masonry/Masonry.h>
#import <RZDataBinding/RZDataBinding.h>

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addNoteButton;
@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MainViewController

- (void)loadView {
    [super loadView];
    
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(0x128B35)];
    
    self.title = @"记录";
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:UIColorFromRGB(0x128B35) forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    [self setUpSearchBar];
    [self setUpAddNoteButton];
    [self setUpTableView];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加密" style:UIBarButtonItemStyleDone target:self action:@selector(login:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FMDBHelper sharedInstance].isSSL && ![[NSUserDefaults standardUserDefaults] boolForKey:@"notepassword_islogined"]) {
        LoginViewController *loginController = [[LoginViewController alloc] init];
        loginController.viewModel.hideBackButton = YES;
        [self.navigationController presentViewController:loginController animated:YES completion:nil];
        return;
    }
    
    NSString *homedi = NSHomeDirectory();
    
    NSLog(@"app path :%@",homedi);
    
}

- (void)viewWillAppear:(BOOL)animated {
   
    [self reloadData];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.searchBar.mas_bottom).offset(0);
        make.bottom.equalTo(self.addNoteButton.mas_top).offset(0);
    }];
    
    [self.tableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setUpAddNoteButton {
    self.addNoteButton = [[UIButton alloc] init];
    [self.addNoteButton addTarget:self action:@selector(addNote:) forControlEvents:UIControlEventTouchUpInside];
    self.addNoteButton.backgroundColor = UIColorFromRGB(0x128B35);
    [self.addNoteButton setTitle:@"添加纪录" forState:UIControlStateNormal];
    [self.view addSubview:self.addNoteButton];
    [self.addNoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
}

- (void)setUpSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"搜索内容";
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = UIColorFromRGB(0x128B35);
    self.searchBar.barTintColor = UIColorFromRGB(0x128B35);
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.top.equalTo(self.view).offset(64);
    }];
}

- (void)addNote:(UIButton *)button {
    AddNoteViewController *addNoteController = [[AddNoteViewController alloc] init];
    [self.navigationController pushViewController:addNoteController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView dataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MainTableViewCell alloc] init];
    }
    
    NoteModel *model = [self.notes objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteModel *model = [self.notes objectAtIndex:indexPath.row];
    NSString *sql = [NSString stringWithFormat:@"delete from note_text where id = %d",model.noteId];
    [[FMDBHelper sharedInstance] deleteNote:sql];
    [self reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteModel *model = [self.notes objectAtIndex:indexPath.row];
    AddNoteViewController *addNoteController = [[AddNoteViewController alloc] init];
    addNoteController.noteModel = model;
    [self.navigationController pushViewController:addNoteController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    [self.searchBar resignFirstResponder];
    NSString *sql = [NSString stringWithFormat:@"select * from note_text where notes like '%%%@%%'",searchText];
    self.notes = [[FMDBHelper sharedInstance] searchNote:sql];
    
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Methods

- (void)reloadData {
    self.notes = [[FMDBHelper sharedInstance] searchNote:@"select * from note_text"];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void)login:(id)object {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"MainViewController dealloc");
}

@end
