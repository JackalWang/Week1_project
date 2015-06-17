//
//  MovieCell.h
//  RottenFruit
//
//  Created by Jackal Wang on 2015/6/16.
//  Copyright (c) 2015年 Jackal Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end
