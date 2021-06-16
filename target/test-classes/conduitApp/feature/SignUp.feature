
Feature: Signing up

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def timeValidator = read('classpath:helpers/timeValidator.js')
    * url apiUrl
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()


Scenario: New user sign up
    Given path 'users'
    And request
    """
       {
            "user": {
                "email": "#(randomEmail)",
                "password": "dagaok2akao1231",
                "username": "#(randomUsername)"
            }
        }
    """ 
    When method Post
    Then status 200
    And match response ==
    """
        {
            "user": {
                "id": "#number",
                "email": #(randomEmail),
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "username": #(randomUsername),
                "bio": null,
                "image": null,
                "token": "#string"
            }
        }
"""


Scenario Outline: Validate sign up error messages
    Given path 'users'
    And request
    """
       {
            "user": {
                "email": "<email>",
                "password": "<password>",
                "username": "<username>"
            }
        }
    """ 
    When method Post
    Then status 422
    And match response == <errorResponse>


Examples: 
    | email              | password  | username                  | errorResponse                                                      |
    | #(randomEmail)     | Karate123 | KarateUser123             | {"errors":{"username":["has already been taken"]}}                 |
    | test093534@test.pl | Karate123 | #(randomUsername)         | {"errors":{"email":["has already been taken"]}}                    |
    | #(randomEmail)     | Karate123 | Karat42222222222222224333 | {"errors":{"username":["is too long (maximum is 20 characters)"]}} |
    | test093test.pl     | Karate123 | #(randomUsername)         | {"errors":{"email":["is invalid"]}}                                |
    | #(randomEmail)     | Ka23      | #(randomUsername)         | {"errors":{"password":["is too short (minimum is 8 characters)"]}} |
    |                    | Karate123 | #(randomUsername)         | {"errors":{"email":["can't be blank"]}}                            |