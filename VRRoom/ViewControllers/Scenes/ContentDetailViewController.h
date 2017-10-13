//
//  ContentDetailViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;

@interface ContentDetailViewController : UIViewController
@property (strong, nonatomic) ContentModel *contentModel;
@property (assign, nonatomic) NSInteger viewType;

@property (copy, nonatomic) void (^collectBlock)(ContentModel *model);

@end
