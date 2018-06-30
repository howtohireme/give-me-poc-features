Feature: staff can review developer applications

  Scenario: approves applicant
    Given system has an 'screening_completed' 'developer' user
    Given system has an 'active' 'staff' user
    When I sign in as 'staff'
    When I open dashboard page
    Then I can access all pages at dashboard
    Then I can see 'developer' in table
    When I open developer profile
    Then I can see 'activate' button
    When I click 'activate' button
    Then I see no applied user
    And user has 'active' state

  Scenario: rejects applicant
    Given system has an 'screening_completed' 'developer' user
    Given system has an 'active' 'staff' user
    When I sign in as 'staff'
    When I open dashboard page
    Then I can see 'developer' in table
    When I open developer profile
    Then I can see 'reject' button
    When I click 'reject' button
    Then I confirm alert
    Then I see no applied user
    And user has 'rejected' state

