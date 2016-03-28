Feature: Log out
  Background:
    Given I have LDAP disabled
    Given I am logged in
    And I have permissions with the following data:
      | model | action |
      | card  | index  |
      | card  | cards  |
      | card  | card   |

  Scenario: User signs out
    Given I am on the home page
    When  I open navigation bar
    When  I click on "Sair"
    Then  I should see "You need to sign in or sign up before continuing."
    And   I should be on the "/users/sign_in" page
