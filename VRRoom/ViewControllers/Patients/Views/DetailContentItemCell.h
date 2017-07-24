//
//  DetailContentItemCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/15.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContentItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentCycleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedTimesLabel;

@end
