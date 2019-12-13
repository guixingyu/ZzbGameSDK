//
//  ZzbDelTipView.h
//  ZzbGameSDK
//
//  Created by isec on 2019/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^DidClickSureBlock) (void);
@interface ZzbDelTipView : UIView
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *desLab;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,copy) DidClickSureBlock didClickSureBlock;
-(void)setTitle:(NSString*)title;
-(void)setDes:(NSString*)des;
@end

NS_ASSUME_NONNULL_END
