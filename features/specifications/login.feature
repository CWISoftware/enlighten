Feature: Login
  Background:
    Given I have LDAP disabled
  
  Scenario: User signs in successfully
    Given a user with email "test@test.com" and password "123456"
      And I have permissions with the following data:
        | model | action |
        | card  | index  |
        | card  | cards  |
        | card  | card   |
    And   I access "/users/sign_in"
    When  I fill in "Email" with "test@test.com"
    And   I fill in "Password" with "123456"
    And   I click on the "Log in" button
    Then  I should see "Signed in successfully."
    And   I should be on the "/" page

  Scenario: User does not have an account
    Given I am on the "/users/sign_in" page
    When  I fill in "Email" with "test@test.com"
    And   I fill in "Password" with "123456"
    And   I click on the "Log in" button
    Then  I should see "Invalid email or password."
    And   I should be on the "/users/sign_in" page

  Scenario: User enters wrong email
    Given a user with email "test@test.com" and password "123456"
    And   I access "/users/sign_in"
    When  I fill in "Email" with "test.com"
    And   I fill in "Password" with "123456"
    And   I click on the "Log in" button
    Then  I should see "Invalid email or password."
    And   I should be on the "/users/sign_in" page

  Scenario: User enters wrong password
    Given a user with email "test@test.com" and password "123456"
    And   I access "/users/sign_in"
    When  I fill in "Email" with "test@test.com"
    And   I fill in "Password" with "12345"
    And   I click on the "Log in" button
    Then  I should see "Invalid email or password."
    And   I should be on the "/users/sign_in" page
