Feature: Person
  Background:
    Given I am logged in

  Scenario: View a person
    Given a "person" with the following data:
      | attribute | value    |
      | name      | John Doe |
    When  I access its url
    Then  I should see "John Doe"

  Scenario: Follow person
    Given a "person"
    And  I am on its url
    When I click on "Follow"
    Then I should see "UNFOLLOW"

  Scenario: Unfollow person
    Given a "person"
    And  I am on its url
    And  I clicked on "Follow"
    When I click on "Unfollow"
    And  I should see "FOLLOW"

  Scenario: Like person
    Given a "person"
    And  I am on its url
    When I click on "Like"
    Then I should see "You liked the person"
    And  I should see "UNLIKE"

  Scenario: Unlike person
    Given a "person"
    And  I am on its url
    And  I clicked on "Like"
    When I click on "Unlike"
    Then I should see "You're not liking the person"
    And  I should see "LIKE"
