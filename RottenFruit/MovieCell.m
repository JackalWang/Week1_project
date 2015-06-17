//
//  MovieCell.m
//  RottenFruit
//
//  Created by Jackal Wang on 2015/6/16.
//  Copyright (c) 2015年 Jackal Wang. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.posterView.image = nil;
}
@end
