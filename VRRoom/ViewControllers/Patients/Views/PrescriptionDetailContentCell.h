//
//  PrescriptionDetailContentCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/15.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionDetailContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
- (void)resetContents:(NSArray *)contents;

@end
