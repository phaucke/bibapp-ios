//
//  BAAccountViewControllerPad.h
//  bibapp
//
//  Created by Johannes Schultze on 20.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAConnectorDelegate.h"
#import "BAAppDelegate.h"
#import "BAAccountTableHeaderViewPad.h"

@interface BAAccountViewControllerPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, BAConnectorDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *loan;
@property (strong, nonatomic) NSMutableArray *reservation;
@property (strong, nonatomic) NSMutableArray *interloan;
@property (strong, nonatomic) NSMutableArray *feesSum;
@property (strong, nonatomic) NSMutableArray *fees;
@property (strong, nonatomic) NSMutableArray *sendEntries;
@property (strong, nonatomic) NSMutableArray *successfulEntries;
@property (strong, nonatomic) NSString *currentAccount;
@property (strong, nonatomic) NSString *currentPassword;
@property (strong, nonatomic) NSString *currentToken;
@property BOOL isLoggingIn;
@property BOOL loggedIn;
@property (weak, nonatomic) IBOutlet UITableView *loanTableView;
@property (weak, nonatomic) IBOutlet UITableView *reservationTableView;
@property (weak, nonatomic) IBOutlet UITableView *feeTableView;
@property (strong, nonatomic) BAAccountTableHeaderViewPad *loanHeader;
@property (strong, nonatomic) BAAccountTableHeaderViewPad *reservationHeader;
@property (strong, nonatomic) BAAccountTableHeaderViewPad *feeHeader;
@property (weak, nonatomic) IBOutlet UINavigationBar *accountNavigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *loanToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *reservationToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *feeToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loanBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reservationBarButton;

- (void)actionButtonClick:(id)sender;

@end
