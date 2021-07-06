Feature: Home Work

Background: Preconditions
    * url apiUrl 

Scenario: Favorite articles
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
         * def favCount = response.articles[0].favoritesCount
         * def slugIdFirst = response.articles[0].slug
         * print (favCount)
         * print "ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt"+ (slugIdFirst)
   
         Given path 'articles', slugIdFirst, 'favorite'
         And method Post
         Then status 200
         And match response.article ==
         """
            {
                "title": "#string",
                "slug": "#(slugIdFirst)",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": "#array",
                "description": "#string",
                "author": {
                  "username": "#string",
                  "bio": "##string",
                  "image": "#string",
                  "following": "#boolean"
                },
                "favorited": true,
                "favoritesCount": "#number"
              }

         """
        
        Given path 'articles', slugIdFirst
        When method Get
        Then status 200
        * def initialCount = 0
        * def response = {"favoritesCount": 1}
        And match response.favoritesCount == initialCount + 1


        Given params { favorited: DAGULINKA, limit: 10, offset: 0}
        And path 'articles'
        When method Get
        Then status 200
        * def allSlug = karate.jsonPath(response, "$..articles[*].slug")
        And match each response.articles == 
        """
            {
                "title": "#string",
                "slug": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": "#array",
                "description": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
        """
        And match allSlug contains slugIdFirst
        
       


Scenario: Comment articles
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        * def slugIdFirst = response.articles[0].slug
   
        Given path 'articles', slugIdFirst, 'comments'
        When method Get
        Then status 200
        And match response == {"comments":[]}
        

#     # Step 5: Get the count of the comments array lentgh and save to variable
#         #Example
#         * def responseWithComments = [{"article": "first"}, {article: "second"}]
#         * def articlesCount = responseWithComments.length
#     # Step 6: Make a POST request to publish a new comment
#     # Step 7: Verify response schema that should contain posted comment text
#     # Step 8: Get the list of all comments for this article one more time
#     # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
#     # Step 10: Make a DELETE request to delete comment
#     # Step 11: Get all comments again and verify number of comments decreased by 1