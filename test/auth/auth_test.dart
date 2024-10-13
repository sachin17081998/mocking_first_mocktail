import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocking_first_mocktail/auth/auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
step 1: we need to create a class named MockSharedPreferences that extends the Mock class and implements the SharedPreferences class.
*/
// syntax: mockClassName extends Mock DependecyToMock {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockLogger extends Mock implements Logger {}

void main() {
//step 2: we will setup the Authentication class so that it can be tested using
//mockSharePrefrence.
  late MockSharedPreferences mockSP;
  late MockLogger mockLogger;
  late Authentication auth;

  // Set up function to initialize common variables before each test
  setUpAll(() {
    mockSP = MockSharedPreferences();
    mockLogger = MockLogger();
    auth = Authentication(localStorage: mockSP, logger: mockLogger);
  });

// step 3: write test for all the functons of the Authentication class
  group('Testing isLoggedIn fucntion', () {
    test('isLoggedIn should return true when user is already logged In', () {
      //Stubbing: we can control the return results of mock objects’ methods by
      //defining what the method should return for this test to execute

      when(() => mockSP.getBool(auth.loginKey)).thenReturn(true);
      /*
      you can put the stubbing (mocking the behavior of methods) inside the 
      setUp() function if the stubbing applies to all tests in a group. However,
       if the stubbing behavior is different for individual tests, you’ll need
        to do the stubbing in each test separately

        .thenReturn: it is used to retun values from a function which not asynchronous
        .thenAnswer: is used to return values from a function whcih is asynchronous
        .thenThrow: it is used to test the exceptions thrown from a function 
      */

      //Act
      final status = auth.isLoggedIn();

      //Assert
      expect(status, true);
    });

    test('isLoggedIn should return false when user is  logged Out', () {
      when(() => mockSP.getBool(auth.loginKey)).thenReturn(false);

      //Act
      final status = auth.isLoggedIn();

      //Assert
      expect(status, false);
    });
  });

  group('Test  cases for setLoginStatus method', () {
    test('should return true when the login status is successfully set',
        () async {
      // Arrange
      const bool status = true;
      //used thenAnswer bcz of asynchronous call
      when(() => mockSP.setBool(auth.loginKey, status))
          .thenAnswer((_) async => true);

      // Act
      final result = await auth.setLoginStatus(status);

      // Assert
      expect(result, true);

      //verify function to check whether a method has been called and how many
      // times it has been called.
      //it is very helpful when we want to test a function that does not return
      //any data
      // below we are verifying that setBool was called only once
      verify(() => mockSP.setBool(auth.loginKey, status)).called(1);
    });

    test(
        'should throw an exception in case of error occured during storing the data',
        () async {
      // Arrangeds
      const bool status = true;
      when(() => mockSP.setBool(auth.loginKey, status))
          .thenThrow(Exception('Failed to set status'));

      // Act
      final call = auth.setLoginStatus(true);

      // Assert
      expect(call, throwsException);
    });
  });

 group('Test for User Name Validator', () {
    test('When text filed is empty', () {
      //Arrange
      String? name = null;

      //act
      final result = auth.validateUserName(name);

      //assert
      expect(result, 'Enter user name');
    });

    test('When name has less than 8 characters', () {
      //Arrange
      String? name = 'Tom';

      //act and assert
      expect(auth.validateUserName(name),
          'name should conatin atleast 4 characters');
    });

    test('When name has more than 16 characters', () {
      //Arrange
      String? name = 'Tom12345678910111213';

      //act and assert
      expect(
          auth.validateUserName(name), 'name can conatin atmost 16 characters');
    });

    test('When name has empty space', () {
      //Arrange
      String? name = 'Scooby Doo';

      //act and assert
      expect(auth.validateUserName(name),
          'user name must not contain empty space');
    });
    test('When name has empty space and less than 4 characters', () {
      //Arrange
      String? name = 'T om';

      //act and assert
      expect(auth.validateUserName(name),
          'user name must not contain empty space');
    });
    test('When name is Valid', () {
      //Arrange
      String? name = 'ScoobyDoo';

      //act and assert
      expect(auth.validateUserName(name), null);
    });
  });

 group('Test For Password Validator', () {
    test('When Password is valid', () {
      //Arrange
      String password = 'ScoobyDoo1';

      //act and assert
      expect(auth.validatePassword(password), null);
    });

    test('When Password has less than 4 characters', () {
      //Arrange
      String password = 'Sc1';

      //act and assert
      expect(auth.validatePassword(password),
          'password should conatin atleast 4 characters');
    });

    test('When Password does not contain a number', () {
      //Arrange
      String password = 'ScoobyDoooo';

      //act and assert
      expect(auth.validatePassword(password),
          'password must contain atleast 1 number');
    });
    test('When Password is Empty', () {
      //Arrange
      String password = '';

      //act and assert
      expect(auth.validatePassword(password), 'Enter Password');
    });
  });

  group('Test for setUserName Method', () {
    test('log method was not called and username is empty', () {
      String name = '';

      auth.setUserName(name);
      verifyNever(() => mockLogger.logMessage(name));
      expect(auth.userName, name);

      verifyNoMoreInteractions(mockLogger);
    });
    test('log function must be called only 1 time when data was updated', () {
      //arrange
      String name = 'Gandalf';

      //act
      auth.setUserName(name);

      // assert
      //verifying number of times external service method was called
      verify(() => mockLogger.logMessage(name)).called(1);
      //asserting the change in data
      expect(auth.userName, name);
      verifyNoMoreInteractions(mockLogger);
    });
  });

  // Teardown function to clean up after each test (optional in this case)
  tearDownAll(() {
    reset(mockSP); 
  });
}
