//
//  ViewController.m
//  SKRC4
//
//  Created by steven on 2015/3/24.
//  Copyright (c) 2015年 KKBOX. All rights reserved.
//

#import "ViewController.h"
#import "SKRC4.h"

@interface ViewController ()

@property (strong, nonatomic) UITextField *keyField;
@property (strong, nonatomic) UITextField *contentField;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIScrollView *basicView;
@end

@implementation ViewController

- (id)init
{
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.basicView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	self.basicView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
	[self.view addSubview:self.basicView];
	
	UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 84.0, 50.0, 50.0)];
	keyLabel.text = @"key";
	[self.basicView addSubview:keyLabel];
	
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, CGRectGetMaxY(keyLabel.frame) + 10.0, 80.0, 50.0)];
	contentLabel.text = @"content";
	[self.basicView addSubview:contentLabel];
	
	self.keyField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame), CGRectGetMinY(keyLabel.frame) + 11.0, self.view.frame.size.width - 114.0, 30.0)];
	self.keyField.borderStyle = UITextBorderStyleRoundedRect;
	self.keyField.returnKeyType = UIReturnKeyDone;
	self.keyField.delegate = (id)self;
	[self.basicView addSubview:self.keyField];
	
	self.contentField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame), CGRectGetMinY(contentLabel.frame) + 11.0, self.view.frame.size.width - 114.0, 30.0)];
	self.contentField.borderStyle = UITextBorderStyleRoundedRect;
	self.contentField.returnKeyType = UIReturnKeyDone;
	self.contentField.delegate = (id)self;
	[self.basicView addSubview:self.contentField];
	
	self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.contentField.frame), self.view.frame.size.width, 50.0)];
	self.pickerView.dataSource = (id)self;
	self.pickerView.delegate = (id)self;
	[self.basicView addSubview:self.pickerView];
	
	self.button = [UIButton buttonWithType:UIButtonTypeSystem];
	self.button.frame = CGRectMake(0.0, CGRectGetMaxY(self.pickerView.frame), self.view.frame.size.width, 30.0);
	[self.button setTitle:@"Tap Me !!" forState:UIControlStateNormal];
	[self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
	[self.basicView addSubview:self.button];
	
	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15.0, CGRectGetMaxY(self.button.frame), self.view.frame.size.width - 30.0, 100.0)];
	self.textView.delegate = (id)self;
	self.textView.editable = NO;
	[self.basicView addSubview:self.textView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField endEditing:YES];
	return YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch (row) {
		case 0:
			return @"encrypt";
			break;
		case 1:
			return @"decrypt";
			break;
		default:
			break;
	}
	return @"";
}

- (void)tap:(id)sender
{
	self.textView.text = @"";
	NSString *key = [self.keyField text];
	NSString *content = [self.contentField text];
	if (![key length] || ![content length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GG" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
	
	NSUInteger select = [self.pickerView selectedRowInComponent:0];
	if (select == 0) {
		self.textView.text = [SKRC4 hexStringFromString:[SKRC4 RC4EncryptionWithKey:key string:content]];
	}
	else {
		NSString *result = [SKRC4 RC4DecryptionWithKey:key string:[SKRC4 stringFromHexString:content]];
		if (![result length]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Key is wrong" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			return;
		}
		self.textView.text = result;
	}
}

- (void)keyboardWillShowNotification:(NSNotification *)inNotification
{
	NSNumber *keyboarAnimDuration = [inNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSValue *keyboardRectValue = [inNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
	
	
	CGRect tuneFrame = [UIScreen mainScreen].bounds;
	tuneFrame.size.height = (tuneFrame.size.height - [keyboardRectValue CGRectValue].size.height);
	[UIView animateWithDuration:[keyboarAnimDuration floatValue] delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
		self.basicView.frame = tuneFrame;
	} completion:nil];
}

- (void)keyboardWillHideNotification:(NSNotification *)inNotification
{
	NSNumber *keyboarAnimDuration = [inNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
	[UIView animateWithDuration:[keyboarAnimDuration floatValue] delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
		self.basicView.frame = [UIScreen mainScreen].bounds;
	} completion:nil];
}

@end
