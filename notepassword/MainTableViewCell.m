//
//  MainTableViewCell.m
//  notepassword
//
//  Created by 刘勇强 on 17/1/28.
//  Copyright © 2017年 notePassword. All rights reserved.
//

#import "MainTableViewCell.h"

#import <Masonry/Masonry.h>

@interface MainTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLable;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpTitleLabel];
        [self setUpDetailLabel];
        [self setUpRightLabel];
    }
    return self;
}

- (void)setUpTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(12);
    }];
}

- (void)setUpDetailLabel {
    self.detailLable = [[UILabel alloc] init];
    self.detailLable.textColor = [UIColor grayColor];
    [self.detailLable setFont:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:self.detailLable];
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setUpRightLabel {
    self.rightLabel = [[UILabel alloc] init];
    [self.rightLabel setFont:[UIFont systemFontOfSize:11]];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = UIColorFromRGB(0x128B35);
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.width.mas_equalTo(100);
    }];
}

- (void)setModel:(NoteModel *)model {
    NSArray *array = [model.notes componentsSeparatedByString:@"\n"];
    self.titleLabel.text = array.firstObject;
    if (array.count > 1) {
        self.detailLable.text = array[1];
    } else {
        self.detailLable.text = @"无附加内容";
    }
    
    self.rightLabel.text = model.updateTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
