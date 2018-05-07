extern NSString* const kCAFilterDestOut;

@interface NSObject (Private)
-(BOOL)isSelected;
@end

@interface CCUIToggleViewController : UIViewController
@property (assign, nonatomic) BOOL isLowPowerModule;
@property (retain, nonatomic) UILabel *percentLabel;
@property (retain, nonatomic) NSObject *module;
@end

@interface CALayer (Private)
@property (nonatomic, retain) NSString *compositingFilter;
@property (nonatomic, assign) BOOL allowsGroupOpacity;
@property (nonatomic, assign) BOOL allowsGroupBlending;
@end

%hook CCUIToggleViewController
%property (assign, nonatomic) BOOL isLowPowerModule;
%property (retain, nonatomic) UILabel *percentLabel;
-(void)viewDidLoad {
  %orig;
  if([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")]){
    self.isLowPowerModule = TRUE;
  }

  if(self.isLowPowerModule){
    self.percentLabel = [[UILabel alloc] init];
    self.percentLabel.textColor = [UIColor whiteColor];
	  self.percentLabel.font = [self.percentLabel.font fontWithSize:10];
    self.percentLabel.layer.allowsGroupBlending = NO;
	  self.percentLabel.layer.allowsGroupOpacity = YES;
    self.percentLabel.layer.compositingFilter = kCAFilterDestOut;
	  [self.view addSubview:self.percentLabel];
  }
}
-(void)viewWillAppear:(BOOL)arg1 {
  %orig(arg1);
  
  int battery = [[UIDevice currentDevice] batteryLevel] * 100;
  self.percentLabel.text = [NSString stringWithFormat:@"%i%%", battery];

  [self.percentLabel sizeToFit];
  self.percentLabel.frame = CGRectMake(self.view.frame.size.width/2 - self.percentLabel.frame.size.width/2, self.view.frame.size.height * 0.70, self.percentLabel.frame.size.width, self.percentLabel.frame.size.height);
}
-(void)refreshState {
  %orig;
  if([self.module isSelected]){
    self.percentLabel.layer.compositingFilter = kCAFilterDestOut;
  } else {
    self.percentLabel.layer.compositingFilter = nil;
  }
}
%end
