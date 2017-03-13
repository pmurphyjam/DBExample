DBExample
=========

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This Application uses CocoaPods, the Podfile is located in the main directory.
You must install CocoaPods, and then run the command in the terminal window in the DBExample directory:
    >pod install;
    >pod update;

The Podfile will install Google Analytics and SQLDataAccess which performs all of your database accesses to the
Contacts.db database using SQLite. The SQLDataAccess class uses the SQLite library libsqlite3.tbd.

Once the Pod is complete, now load the DBExample.xcworkspace in Xcode. 
This App was built with Xcode 8.2.1, and is designed to run in iOS10.2+.

This DBExample edits an existing Company table, you can insert, delete, or update a Company, and also 
get all the existing company's via a simple select statement.
The CompanyModel defines all the SQL queries necessary to run this demo, and shows you how to write
simple SQL queries using SQLDataAccess. The CompanyConvertor converts the data returned from SQLDataAccess
which is in the form of a MutableArray of Dictionaries into a CompanyObject which is what is used in
CompanyTableViewController.

The SQLDataAccess : AppConstants has a DB_FILE and DB_FILEX define it which you can reassign in your
AppDelegate.m so SQLDataAccess can find your database which must be located in the NSBundle.
The Category SettingsModel+Category is an extension of the SQLDataAccess : SettingsModel, this uses
NSUserDefaults to store all your register data for the App. If you're using SQLCipher the encryption register
[SettingsModel setDBPW0:] is used to set the Encryption key into SQLCipher. The SQLDataAccess.m class has
lots of comments in it for how to setup SQLCipher.

In addition this App incorporates Google Analytics, you will need to set your own AnalyticsIdentifier in
the DBExample-Info.plist.

Note : In the DBExample Xcode project : Build Phases, there is a Run Script that creates your GitCommit,
and BuildDate and these are stored in the SettingsModel.
