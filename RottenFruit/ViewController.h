//
//  ViewController.h
//  RottenFruit
//
//  Created by Jackal Wang on 2015/6/12.
//  Copyright (c) 2015年 Jackal Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@property (strong,nonatomic) NSDictionary *movie;

@end

