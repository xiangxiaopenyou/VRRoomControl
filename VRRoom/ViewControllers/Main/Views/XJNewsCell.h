//
//  XJNewsCell.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/22.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
