//
//  ACTabBarViewItem.h
//  iPadMagazine
//
//  Created by Francisco Gindre on 1/17/11.
//  Copyright 2011 AppCrafter.biz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ACTabBarView;
typedef enum {
	ACTabBarItemStateSelected,
	ACTabBarItemStateNormal,
	ACTabBarItemStateDisabled,
	kACTabBarItemStateCount,
}ACTabBarItemState;

@interface ACTabBarItem : UIView {
	UIViewController *viewController;
	
	ACTabBarItemState state;
	NSInteger index;
	UILabel *_text;
	
	@private
	NSMutableArray *_imageArray;
	
	UIImageView *imageView;
}
@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic, setter = setState:, getter = getState) ACTabBarItemState state;
@property (nonatomic) NSInteger index; // set by the ACTabBarView
@property (nonatomic,strong) UILabel *_text;
-(id)initWithViewController:(UIViewController*)theViewController image:(UIImage*)normalStateImage andtext:(NSString*)textOrNil;

-(void)setImage:(UIImage*)image forState:(ACTabBarItemState)state ;


@end
