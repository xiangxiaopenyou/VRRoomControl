//
//  PrescriptionCell.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^endBlock)();

@interface PrescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (copy, nonatomic) endBlock block;

@end
