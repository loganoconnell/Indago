@interface IndagoSearchBarViewController : UIViewController <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIVisualEffectView *darkEffectView;
@property (nonatomic, strong) UIVisualEffectView *lightEffectView;
@property (nonatomic, strong) UIImageView *fakeStatusBar;

@property (nonatomic, assign) BOOL isNotOnHomeScreen;
@property (nonatomic, assign) BOOL shouldUseLightMode;
@property (nonatomic, assign) float searchBarPushDownPercentage;
@end