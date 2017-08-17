//
//  SelectSexCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/31.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectBlock)(XJUserSex userSex);

@interface SelectSexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (nonatomic) BOOL editable;
@property (copy, nonatomic) selectBlock block;

@end
