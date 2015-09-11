Feature: Activity
  Background:
    Given I am logged in

  Scenario: Post text activity on person
    Given a "person" with the following data:
      | attribute | value    |
      | name      | John Doe |
    When  I access its url
    And   I type "This is a sample post" on the filed with "Have something nice to say?" placeholder
    When  I click on the "Post" button
    Then  I should see "This is a sample post"

  Scenario: Post text activity on project
    Given a "project" with the following data:
      | attribute   | value               |
      | name        | Test Project        |
      | description | Project description |
    When  I access its url
    And   I type "This is a sample post" on the filed with "Have something nice to say?" placeholder
    When  I click on the "Post" button
    Then  I should see "This is a sample post"

  Scenario: Post text activity on technology
    Given a "technology" with the following data:
      | attribute | value                     |
      | name      | Ruby                      |
      | website   | https://www.ruby-lang.org |
    When  I access its url
    And   I type "This is a sample post" on the filed with "Have something nice to say?" placeholder
    When  I click on the "Post" button
    Then  I should see "This is a sample post"
