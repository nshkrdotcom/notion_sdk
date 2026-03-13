> ## Documentation Index
> Fetch the complete documentation index at: https://developers.notion.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Retrieve a page property item

Retrieves a `property_item` object for a given `page_id` and `property_id`. Depending on the property type, the object returned will either be a value or a [paginated](/reference/pagination) list of property item values. See [Property item objects](/reference/property-item-object) for specifics.

To obtain `property_id`s, use the [Retrieve a database](/reference/retrieve-a-database) endpoint.

In cases where a property item has more than 25 references, this endpoint should be used, rather than [Retrieve a page](/reference/retrieve-a-page). ([Retrieve a page](/reference/retrieve-a-page) will not return a complete list when the list exceeds 25 references.)

## Property Item Objects

For more detailed information refer to the [Property item object documentation](/reference/property-item-object)

### Simple Properties

Each individual `property_item` properties will have a `type` and under the the key with the value for `type`, an object that identifies the property value, documented under [Property value objects](/reference/page#property-value-object).

### Paginated Properties

Property types that return a paginated list of property item objects are:

* `title`
* `rich_text`
* `relation`
* `people`

Look for the `next_url` value in the response object for these property items to view paginated results. Refer to [paginated page properties](/reference/page-property-values#paginated-page-properties) for a full description of the response object for these properties.

Refer to the [pagination reference](/reference/intro#pagination) for details on how to iterate through a results list.

### Rollup Properties

<Check>
  Learn more about rollup properties on the [Page properties page](/reference/page-property-values#rollup) or in Notion’s [Help Center](https://www.notion.so/help/relations-and-rollups).
</Check>

For regular "Show original" rollups, the endpoint returns a flattened list of all the property items in the rollup.

For rollups with an aggregation, the API returns a [rollup property value](/reference/page#rollup-property-values) under the `rollup` key and the list of relations.

In order to avoid timeouts, if the rollup has a with a large number of aggregations or properties the endpoint returns a `next_cursor` value that is used to determinate the aggregation value *so far* for the subset of relations that have been paginated through.

Once `has_more` is `false`, then the final rollup value is returned. Refer to the [Pagination documentation](/reference/pagination) for more information on pagination in the Notion API.

Computing the values of following aggregations are *not* supported. Instead the endpoint returns a list of `property_item` objects for the rollup:

* `show_unique` (Show unique values)
* `unique` (Count unique values)
* `median`(Median)

<Info>
  **Integration capabilities**

  This endpoint requires an integration to have read content capabilities. Attempting to call this API without read content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](/reference/capabilities).
</Info>

### Errors

Returns a 404 HTTP response if the page or property doesn't exist, or if the integration doesn't have access to the page.

Returns a 400 or 429 HTTP response if the request exceeds the [request limits](/reference/request-limits).

*Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](/reference/status-codes#error-codes) of the Status codes documentation for more information.*


## OpenAPI

````yaml get /v1/pages/{page_id}/properties/{property_id}
openapi: 3.1.0
info:
  title: Notion API
  version: 1.0.0
  termsOfService: >-
    https://notion.notion.site/Terms-and-Privacy-28ffdd083dc3473e9c2da6ec011b58ac
servers:
  - url: https://api.notion.com
security:
  - bearerAuth: []
tags:
  - name: Databases
    description: Database endpoints
  - name: Data sources
    description: Data source endpoints
  - name: Pages
    description: Page endpoints
  - name: Blocks
    description: Block endpoints
  - name: Comments
    description: Comment endpoints
  - name: File uploads
    description: File upload endpoints
  - name: OAuth
    description: OAuth endpoints (basic authentication)
  - name: Users
    description: User endpoints
  - name: Search
    description: Search endpoints
paths:
  /v1/pages/{page_id}/properties/{property_id}:
    get:
      tags:
        - Pages
      summary: Retrieve a page property item
      operationId: retrieve-a-page-property
      parameters:
        - name: page_id
          in: path
          required: true
          schema:
            $ref: '#/components/schemas/idRequest'
        - name: property_id
          in: path
          required: true
          schema:
            type: string
        - name: start_cursor
          in: query
          schema:
            type: string
        - name: page_size
          in: query
          schema:
            type: integer
        - $ref: '#/components/parameters/notionVersion'
      responses:
        '200':
          description: ''
          content:
            application/json:
              schema:
                anyOf:
                  - $ref: '#/components/schemas/propertyItemObjectResponse'
                  - $ref: '#/components/schemas/propertyItemListResponse'
        '400':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_400'
        '401':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_401'
        '403':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_403'
        '404':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_404'
        '409':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_409'
        '429':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_429'
        '500':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_500'
        '503':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_api_503'
      x-codeSamples:
        - lang: javascript
          label: TypeScript SDK
          source: |-
            import { Client } from "@notionhq/client"

            const notion = new Client({ auth: process.env.NOTION_API_KEY })

            const response = await notion.pages.properties.retrieve({
              page_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
              property_id: "aBcD"
            })
components:
  schemas:
    idRequest:
      type: string
    propertyItemObjectResponse:
      anyOf:
        - $ref: '#/components/schemas/numberPropertyItemObjectResponse'
        - $ref: '#/components/schemas/urlPropertyItemObjectResponse'
        - $ref: '#/components/schemas/selectPropertyItemObjectResponse'
        - $ref: '#/components/schemas/multiSelectPropertyItemObjectResponse'
        - $ref: '#/components/schemas/statusPropertyItemObjectResponse'
        - $ref: '#/components/schemas/datePropertyItemObjectResponse'
        - $ref: '#/components/schemas/emailPropertyItemObjectResponse'
        - $ref: '#/components/schemas/phoneNumberPropertyItemObjectResponse'
        - $ref: '#/components/schemas/checkboxPropertyItemObjectResponse'
        - $ref: '#/components/schemas/filesPropertyItemObjectResponse'
        - $ref: '#/components/schemas/createdByPropertyItemObjectResponse'
        - $ref: '#/components/schemas/createdTimePropertyItemObjectResponse'
        - $ref: '#/components/schemas/lastEditedByPropertyItemObjectResponse'
        - $ref: '#/components/schemas/lastEditedTimePropertyItemObjectResponse'
        - $ref: '#/components/schemas/formulaPropertyItemObjectResponse'
        - $ref: '#/components/schemas/buttonPropertyItemObjectResponse'
        - $ref: '#/components/schemas/uniqueIdPropertyItemObjectResponse'
        - $ref: '#/components/schemas/verificationPropertyItemObjectResponse'
        - $ref: '#/components/schemas/placePropertyItemObjectResponse'
        - $ref: '#/components/schemas/titlePropertyItemObjectResponse'
        - $ref: '#/components/schemas/richTextPropertyItemObjectResponse'
        - $ref: '#/components/schemas/peoplePropertyItemObjectResponse'
        - $ref: '#/components/schemas/relationPropertyItemObjectResponse'
        - $ref: '#/components/schemas/rollupPropertyItemObjectResponse'
    propertyItemListResponse:
      $ref: '#/components/schemas/propertyItemPropertyItemListResponse'
    error_api_400:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - invalid_json
                - invalid_request_url
                - invalid_request
                - missing_version
                - validation_error
            status:
              const: 400
          required:
            - code
            - status
          additionalProperties: false
    error_api_401:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - unauthorized
            status:
              const: 401
          required:
            - code
            - status
          additionalProperties: false
    error_api_403:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - restricted_resource
            status:
              const: 403
          required:
            - code
            - status
          additionalProperties: false
    error_api_404:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - object_not_found
            status:
              const: 404
          required:
            - code
            - status
          additionalProperties: false
    error_api_409:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - conflict_error
            status:
              const: 409
          required:
            - code
            - status
          additionalProperties: false
    error_api_429:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - rate_limited
            status:
              const: 429
          required:
            - code
            - status
          additionalProperties: false
    error_api_500:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - internal_server_error
            status:
              const: 500
          required:
            - code
            - status
          additionalProperties: false
    error_api_503:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - service_unavailable
            status:
              const: 503
          required:
            - code
            - status
          additionalProperties: false
    numberPropertyItemObjectResponse:
      title: Number
      type: object
      properties:
        type:
          type: string
          const: number
        number:
          type:
            - number
            - 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - number
        - object
        - id
    urlPropertyItemObjectResponse:
      title: Url
      type: object
      properties:
        type:
          type: string
          const: url
        url:
          type:
            - string
            - 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - url
        - object
        - id
    selectPropertyItemObjectResponse:
      title: Select
      type: object
      properties:
        type:
          type: string
          const: select
        select:
          anyOf:
            - $ref: '#/components/schemas/partialSelectResponse'
            - type: 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - select
        - object
        - id
    multiSelectPropertyItemObjectResponse:
      title: Multi Select
      type: object
      properties:
        type:
          type: string
          const: multi_select
        multi_select:
          type: array
          items:
            $ref: '#/components/schemas/partialSelectResponse'
          maxItems: 100
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - multi_select
        - object
        - id
    statusPropertyItemObjectResponse:
      title: Status
      type: object
      properties:
        type:
          type: string
          const: status
        status:
          anyOf:
            - $ref: '#/components/schemas/partialSelectResponse'
            - type: 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - status
        - object
        - id
    datePropertyItemObjectResponse:
      title: Date
      type: object
      properties:
        type:
          type: string
          const: date
        date:
          anyOf:
            - $ref: '#/components/schemas/dateResponse'
            - type: 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - date
        - object
        - id
    emailPropertyItemObjectResponse:
      title: Email
      type: object
      properties:
        type:
          type: string
          const: email
        email:
          type:
            - string
            - 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - email
        - object
        - id
    phoneNumberPropertyItemObjectResponse:
      title: Phone Number
      type: object
      properties:
        type:
          type: string
          const: phone_number
        phone_number:
          type:
            - string
            - 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - phone_number
        - object
        - id
    checkboxPropertyItemObjectResponse:
      title: Checkbox
      type: object
      properties:
        type:
          type: string
          const: checkbox
        checkbox:
          type: boolean
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - checkbox
        - object
        - id
    filesPropertyItemObjectResponse:
      title: Files
      type: object
      properties:
        type:
          type: string
          const: files
        files:
          type: array
          items:
            $ref: '#/components/schemas/internalOrExternalFileWithNameResponse'
          maxItems: 100
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - files
        - object
        - id
    createdByPropertyItemObjectResponse:
      title: Created By
      type: object
      properties:
        type:
          type: string
          const: created_by
        created_by:
          anyOf:
            - $ref: '#/components/schemas/partialUserObjectResponse'
            - $ref: '#/components/schemas/userObjectResponse'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - created_by
        - object
        - id
    createdTimePropertyItemObjectResponse:
      title: Created Time
      type: object
      properties:
        type:
          type: string
          const: created_time
        created_time:
          type: string
          format: date-time
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - created_time
        - object
        - id
    lastEditedByPropertyItemObjectResponse:
      title: Last Edited By
      type: object
      properties:
        type:
          type: string
          const: last_edited_by
        last_edited_by:
          anyOf:
            - $ref: '#/components/schemas/partialUserObjectResponse'
            - $ref: '#/components/schemas/userObjectResponse'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - last_edited_by
        - object
        - id
    lastEditedTimePropertyItemObjectResponse:
      title: Last Edited Time
      type: object
      properties:
        type:
          type: string
          const: last_edited_time
        last_edited_time:
          type: string
          format: date-time
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - last_edited_time
        - object
        - id
    formulaPropertyItemObjectResponse:
      title: Formula
      type: object
      properties:
        type:
          type: string
          const: formula
        formula:
          $ref: '#/components/schemas/formulaPropertyResponse'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - formula
        - object
        - id
    buttonPropertyItemObjectResponse:
      title: Button
      type: object
      properties:
        type:
          type: string
          const: button
        button:
          $ref: '#/components/schemas/emptyObject'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - button
        - object
        - id
    uniqueIdPropertyItemObjectResponse:
      title: Unique Id
      type: object
      properties:
        type:
          type: string
          const: unique_id
        unique_id:
          type: object
          properties:
            prefix:
              type:
                - string
                - 'null'
            number:
              type:
                - number
                - 'null'
          required:
            - prefix
            - number
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - unique_id
        - object
        - id
    verificationPropertyItemObjectResponse:
      title: Verification
      type: object
      properties:
        type:
          type: string
          const: verification
        verification:
          anyOf:
            - $ref: '#/components/schemas/verificationPropertyValueResponse'
            - type: 'null'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - verification
        - object
        - id
    placePropertyItemObjectResponse:
      title: Place
      type: object
      properties:
        type:
          type: string
          const: place
        place:
          type:
            - object
            - 'null'
          properties:
            lat:
              type: number
            lon:
              type: number
            name:
              type:
                - string
                - 'null'
            address:
              type:
                - string
                - 'null'
            aws_place_id:
              type:
                - string
                - 'null'
            google_place_id:
              type:
                - string
                - 'null'
          required:
            - lat
            - lon
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - place
        - object
        - id
    titlePropertyItemObjectResponse:
      title: Title
      type: object
      properties:
        type:
          type: string
          const: title
        title:
          $ref: '#/components/schemas/richTextItemResponse'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - title
        - object
        - id
    richTextPropertyItemObjectResponse:
      title: Rich Text
      type: object
      properties:
        type:
          type: string
          const: rich_text
        rich_text:
          $ref: '#/components/schemas/richTextItemResponse'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - rich_text
        - object
        - id
    peoplePropertyItemObjectResponse:
      title: People
      type: object
      properties:
        type:
          type: string
          const: people
        people:
          anyOf:
            - $ref: '#/components/schemas/partialUserObjectResponse'
            - $ref: '#/components/schemas/userObjectResponse'
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - people
        - object
        - id
    relationPropertyItemObjectResponse:
      title: Relation
      type: object
      properties:
        type:
          type: string
          const: relation
        relation:
          type: object
          properties:
            id:
              type: string
              format: uuid
          required:
            - id
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - relation
        - object
        - id
    rollupPropertyItemObjectResponse:
      title: Rollup
      type: object
      properties:
        type:
          type: string
          const: rollup
        rollup:
          anyOf:
            - title: Number
              type: object
              properties:
                type:
                  type: string
                  const: number
                number:
                  type:
                    - number
                    - 'null'
                function:
                  $ref: '#/components/schemas/rollupFunction'
              required:
                - type
                - number
                - function
            - title: Date
              type: object
              properties:
                type:
                  type: string
                  const: date
                date:
                  anyOf:
                    - $ref: '#/components/schemas/dateResponse'
                    - type: 'null'
                function:
                  $ref: '#/components/schemas/rollupFunction'
              required:
                - type
                - date
                - function
            - title: Array
              type: object
              properties:
                type:
                  type: string
                  const: array
                array:
                  type: array
                  items:
                    $ref: '#/components/schemas/emptyObject'
                  maxItems: 100
                function:
                  $ref: '#/components/schemas/rollupFunction'
              required:
                - type
                - array
                - function
            - title: Unsupported
              type: object
              properties:
                type:
                  type: string
                  const: unsupported
                unsupported:
                  $ref: '#/components/schemas/emptyObject'
                function:
                  $ref: '#/components/schemas/rollupFunction'
              required:
                - type
                - unsupported
                - function
            - title: Incomplete
              type: object
              properties:
                type:
                  type: string
                  const: incomplete
                incomplete:
                  $ref: '#/components/schemas/emptyObject'
                function:
                  $ref: '#/components/schemas/rollupFunction'
              required:
                - type
                - incomplete
                - function
        object:
          type: string
          const: property_item
        id:
          type: string
      required:
        - type
        - rollup
        - object
        - id
    propertyItemPropertyItemListResponse:
      title: Property Item
      type: object
      properties:
        type:
          type: string
          const: property_item
        property_item:
          anyOf:
            - title: Title
              type: object
              properties:
                type:
                  type: string
                  const: title
                title:
                  $ref: '#/components/schemas/emptyObject'
                next_url:
                  type:
                    - string
                    - 'null'
                id:
                  type: string
              required:
                - type
                - title
                - next_url
                - id
            - title: Rich Text
              type: object
              properties:
                type:
                  type: string
                  const: rich_text
                rich_text:
                  $ref: '#/components/schemas/emptyObject'
                next_url:
                  type:
                    - string
                    - 'null'
                id:
                  type: string
              required:
                - type
                - rich_text
                - next_url
                - id
            - title: People
              type: object
              properties:
                type:
                  type: string
                  const: people
                people:
                  $ref: '#/components/schemas/emptyObject'
                next_url:
                  type:
                    - string
                    - 'null'
                id:
                  type: string
              required:
                - type
                - people
                - next_url
                - id
            - title: Relation
              type: object
              properties:
                type:
                  type: string
                  const: relation
                relation:
                  $ref: '#/components/schemas/emptyObject'
                next_url:
                  type:
                    - string
                    - 'null'
                id:
                  type: string
              required:
                - type
                - relation
                - next_url
                - id
            - title: Rollup
              type: object
              properties:
                type:
                  type: string
                  const: rollup
                rollup:
                  anyOf:
                    - title: Number
                      type: object
                      properties:
                        type:
                          type: string
                          const: number
                        number:
                          type:
                            - number
                            - 'null'
                        function:
                          $ref: '#/components/schemas/rollupFunction'
                      required:
                        - type
                        - number
                        - function
                    - title: Date
                      type: object
                      properties:
                        type:
                          type: string
                          const: date
                        date:
                          anyOf:
                            - $ref: '#/components/schemas/dateResponse'
                            - type: 'null'
                        function:
                          $ref: '#/components/schemas/rollupFunction'
                      required:
                        - type
                        - date
                        - function
                    - title: Array
                      type: object
                      properties:
                        type:
                          type: string
                          const: array
                        array:
                          type: array
                          items:
                            $ref: '#/components/schemas/emptyObject'
                          maxItems: 100
                        function:
                          $ref: '#/components/schemas/rollupFunction'
                      required:
                        - type
                        - array
                        - function
                    - title: Unsupported
                      type: object
                      properties:
                        type:
                          type: string
                          const: unsupported
                        unsupported:
                          $ref: '#/components/schemas/emptyObject'
                        function:
                          $ref: '#/components/schemas/rollupFunction'
                      required:
                        - type
                        - unsupported
                        - function
                    - title: Incomplete
                      type: object
                      properties:
                        type:
                          type: string
                          const: incomplete
                        incomplete:
                          $ref: '#/components/schemas/emptyObject'
                        function:
                          $ref: '#/components/schemas/rollupFunction'
                      required:
                        - type
                        - incomplete
                        - function
                next_url:
                  type:
                    - string
                    - 'null'
                id:
                  type: string
              required:
                - type
                - rollup
                - next_url
                - id
        object:
          type: string
          const: list
        next_cursor:
          type:
            - string
            - 'null'
        has_more:
          type: boolean
        results:
          type: array
          items:
            $ref: '#/components/schemas/propertyItemObjectResponse'
      required:
        - type
        - property_item
        - object
        - next_cursor
        - has_more
        - results
    publicApiCommonErrorResponse:
      type: object
      properties:
        object:
          const: error
        message:
          type: string
        additional_data:
          type: object
          additionalProperties:
            oneOf:
              - type: string
              - type: array
                items:
                  type: string
      required:
        - object
        - message
    partialSelectResponse:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        color:
          $ref: '#/components/schemas/selectColor'
      required:
        - id
        - name
        - color
    dateResponse:
      type: object
      properties:
        start:
          type: string
          format: date
          description: The start date of the date object.
        end:
          oneOf:
            - type: string
              format: date
            - type: 'null'
          description: The end date of the date object, if any.
        time_zone:
          oneOf:
            - $ref: '#/components/schemas/timeZoneRequest'
            - type: 'null'
          description: The time zone of the date object.
      additionalProperties: false
      required:
        - start
        - end
        - time_zone
    internalOrExternalFileWithNameResponse:
      allOf:
        - $ref: '#/components/schemas/internalOrExternalFileWithNameResponseCommon'
        - oneOf:
            - $ref: '#/components/schemas/fileInternalOrExternalFileWithNameResponse'
            - $ref: >-
                #/components/schemas/externalInternalOrExternalFileWithNameResponse
    partialUserObjectResponse:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/idResponse'
        object:
          type: string
          const: user
          description: Always `user`
      additionalProperties: false
      required:
        - id
        - object
    userObjectResponse:
      allOf:
        - $ref: '#/components/schemas/userObjectResponseCommon'
        - oneOf:
            - $ref: '#/components/schemas/personUserObjectResponse'
            - $ref: '#/components/schemas/botUserObjectResponse'
    formulaPropertyResponse:
      anyOf:
        - $ref: '#/components/schemas/stringFormulaPropertyResponse'
        - $ref: '#/components/schemas/dateFormulaPropertyResponse'
        - $ref: '#/components/schemas/numberFormulaPropertyResponse'
        - $ref: '#/components/schemas/booleanFormulaPropertyResponse'
    emptyObject:
      type: object
      properties: {}
      additionalProperties: false
    verificationPropertyValueResponse:
      oneOf:
        - $ref: '#/components/schemas/verificationPropertyUnverifiedResponse'
        - $ref: '#/components/schemas/verificationPropertyResponse'
    richTextItemResponse:
      allOf:
        - $ref: '#/components/schemas/richTextItemResponseCommon'
        - oneOf:
            - $ref: '#/components/schemas/textRichTextItemResponse'
            - $ref: '#/components/schemas/mentionRichTextItemResponse'
            - $ref: '#/components/schemas/equationRichTextItemResponse'
    rollupFunction:
      type: string
      enum:
        - count
        - count_values
        - empty
        - not_empty
        - unique
        - show_unique
        - percent_empty
        - percent_not_empty
        - sum
        - average
        - median
        - min
        - max
        - range
        - earliest_date
        - latest_date
        - date_range
        - checked
        - unchecked
        - percent_checked
        - percent_unchecked
        - count_per_group
        - percent_per_group
        - show_original
    selectColor:
      type: string
      enum:
        - default
        - gray
        - brown
        - orange
        - yellow
        - green
        - blue
        - purple
        - pink
        - red
      description: >-
        One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`,
        `purple`, `pink`, `red`
    timeZoneRequest:
      type: string
    internalOrExternalFileWithNameResponseCommon:
      type: object
      properties:
        name:
          type: string
          description: The name of the file.
      additionalProperties: false
      required:
        - name
    fileInternalOrExternalFileWithNameResponse:
      type: object
      properties:
        type:
          type: string
          const: file
          description: >-
            Type of attachment. In this case, a file uploaded to a Notion
            workspace.
        file:
          $ref: '#/components/schemas/internalFileResponse'
          description: The file URL.
      required:
        - type
        - file
      title: File
    externalInternalOrExternalFileWithNameResponse:
      type: object
      properties:
        type:
          type: string
          const: external
          description: Type of attachment. In this case, an external URL.
        external:
          type: object
          properties:
            url:
              type: string
              description: The URL of the external file or resource.
          additionalProperties: false
          required:
            - url
          description: The external URL.
      required:
        - type
        - external
      title: External
    idResponse:
      type: string
      format: uuid
    userObjectResponseCommon:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the user.
        object:
          type: string
          const: user
          description: The user object type name.
        name:
          oneOf:
            - type: string
            - type: 'null'
          description: The name of the user.
        avatar_url:
          oneOf:
            - type: string
            - type: 'null'
          description: The avatar URL of the user.
      additionalProperties: false
      required:
        - id
        - object
        - name
        - avatar_url
    personUserObjectResponse:
      type: object
      properties:
        type:
          type: string
          const: person
          description: Indicates this user is a person.
        person:
          type: object
          properties:
            email:
              type: string
              description: The email of the person.
          additionalProperties: false
          description: Details about the person, when the `type` of the user is `person`.
      required:
        - type
        - person
      title: Person
    botUserObjectResponse:
      type: object
      properties:
        type:
          type: string
          const: bot
          description: Indicates this user is a bot.
        bot:
          oneOf:
            - $ref: '#/components/schemas/emptyObject'
            - $ref: '#/components/schemas/botInfoResponse'
          description: Details about the bot, when the `type` of the user is `bot`.
      required:
        - type
        - bot
      title: Bot
    stringFormulaPropertyResponse:
      title: String
      type: object
      properties:
        type:
          type: string
          const: string
        string:
          type:
            - string
            - 'null'
      required:
        - type
        - string
    dateFormulaPropertyResponse:
      title: Date
      type: object
      properties:
        type:
          type: string
          const: date
        date:
          anyOf:
            - $ref: '#/components/schemas/dateResponse'
            - type: 'null'
      required:
        - type
        - date
    numberFormulaPropertyResponse:
      title: Number
      type: object
      properties:
        type:
          type: string
          const: number
        number:
          type:
            - number
            - 'null'
      required:
        - type
        - number
    booleanFormulaPropertyResponse:
      title: Boolean
      type: object
      properties:
        type:
          type: string
          const: boolean
        boolean:
          type:
            - boolean
            - 'null'
      required:
        - type
        - boolean
    verificationPropertyUnverifiedResponse:
      type: object
      properties:
        state:
          type: string
          const: unverified
          description: Always `unverified`
        date:
          type: 'null'
        verified_by:
          type: 'null'
      additionalProperties: false
      required:
        - state
        - date
        - verified_by
      title: Unverified
    verificationPropertyResponse:
      type: object
      properties:
        state:
          type: string
          enum:
            - verified
            - expired
          description: 'One of: `verified`, `expired`'
        date:
          oneOf:
            - $ref: '#/components/schemas/dateResponse'
            - type: 'null'
        verified_by:
          oneOf:
            - $ref: '#/components/schemas/partialUserObjectResponse'
            - type: 'null'
      additionalProperties: false
      required:
        - state
        - date
        - verified_by
      title: Verified
    richTextItemResponseCommon:
      type: object
      properties:
        plain_text:
          type: string
          description: The plain text content of the rich text object, without any styling.
        href:
          oneOf:
            - type: string
            - type: 'null'
          description: A URL that the rich text object links to or mentions.
        annotations:
          $ref: '#/components/schemas/annotationResponse'
          description: >-
            All rich text objects contain an annotations object that sets the
            styling for the rich text.
      additionalProperties: false
      required:
        - plain_text
        - href
        - annotations
    textRichTextItemResponse:
      type: object
      properties:
        type:
          type: string
          const: text
          description: Always `text`
        text:
          type: object
          properties:
            content:
              type: string
              maxLength: 2000
              description: The actual text content of the text.
            link:
              oneOf:
                - type: object
                  properties:
                    url:
                      type: string
                      examples:
                        - https://www.notion.com
                      description: The URL of the link.
                  additionalProperties: false
                  required:
                    - url
                - type: 'null'
              description: >-
                An object with information about any inline link in this text,
                if included.
          additionalProperties: false
          required:
            - content
            - link
          description: >-
            If a rich text object's type value is `text`, then the corresponding
            text field contains an object including the text content and any
            inline link.
      required:
        - type
        - text
      title: Text
    mentionRichTextItemResponse:
      type: object
      properties:
        type:
          type: string
          const: mention
          description: Always `mention`
        mention:
          oneOf:
            - type: object
              properties:
                type:
                  type: string
                  const: user
                  description: Always `user`
                user:
                  $ref: '#/components/schemas/userValueResponse'
                  description: Details of the user mention.
              additionalProperties: false
              required:
                - type
                - user
              title: User
            - type: object
              properties:
                type:
                  type: string
                  const: date
                  description: Always `date`
                date:
                  $ref: '#/components/schemas/dateResponse'
                  description: Details of the date mention.
              additionalProperties: false
              required:
                - type
                - date
              title: Date
            - type: object
              properties:
                type:
                  type: string
                  const: link_preview
                  description: Always `link_preview`
                link_preview:
                  $ref: '#/components/schemas/linkPreviewMentionResponse'
                  description: Details of the link preview mention.
              additionalProperties: false
              required:
                - type
                - link_preview
              title: Link Preview
            - type: object
              properties:
                type:
                  type: string
                  const: link_mention
                  description: Always `link_mention`
                link_mention:
                  $ref: '#/components/schemas/linkMentionResponse'
                  description: Details of the link mention.
              additionalProperties: false
              required:
                - type
                - link_mention
              title: Link Mention
            - type: object
              properties:
                type:
                  type: string
                  const: page
                  description: Always `page`
                page:
                  type: object
                  properties:
                    id:
                      $ref: '#/components/schemas/idResponse'
                      description: The ID of the page in the mention.
                  additionalProperties: false
                  required:
                    - id
                  description: Details of the page mention.
              additionalProperties: false
              required:
                - type
                - page
              title: Page
            - type: object
              properties:
                type:
                  type: string
                  const: database
                  description: Always `database`
                database:
                  type: object
                  properties:
                    id:
                      $ref: '#/components/schemas/idResponse'
                      description: The ID of the database in the mention.
                  additionalProperties: false
                  required:
                    - id
                  description: Details of the database mention.
              additionalProperties: false
              required:
                - type
                - database
              title: Database
            - type: object
              properties:
                type:
                  type: string
                  const: template_mention
                  description: Always `template_mention`
                template_mention:
                  $ref: '#/components/schemas/templateMentionResponse'
                  description: Details of the template mention.
              additionalProperties: false
              required:
                - type
                - template_mention
              title: Template Mention
            - type: object
              properties:
                type:
                  type: string
                  const: custom_emoji
                  description: Always `custom_emoji`
                custom_emoji:
                  $ref: '#/components/schemas/customEmojiResponse'
                  description: Details of the custom emoji mention.
              additionalProperties: false
              required:
                - type
                - custom_emoji
              title: Custom Emoji
          description: >-
            Mention objects represent an inline mention of a database, date,
            link preview mention, page, template mention, or user. A mention is
            created in the Notion UI when a user types `@` followed by the name
            of the reference.
      required:
        - type
        - mention
      title: Mention
    equationRichTextItemResponse:
      type: object
      properties:
        type:
          type: string
          const: equation
          description: Always `equation`
        equation:
          type: object
          properties:
            expression:
              type: string
              examples:
                - e=mc^2
              description: A KaTeX compatible string.
          additionalProperties: false
          required:
            - expression
          description: >-
            Notion supports inline LaTeX equations as rich text objects with a
            type value of `equation`.
      required:
        - type
        - equation
      title: Equation
    internalFileResponse:
      type: object
      properties:
        url:
          type: string
          description: The URL of the file.
        expiry_time:
          type: string
          format: date-time
          description: The time when the URL will expire.
      additionalProperties: false
      required:
        - url
        - expiry_time
    botInfoResponse:
      type: object
      properties:
        owner:
          oneOf:
            - type: object
              properties:
                type:
                  type: string
                  const: user
                  description: Always `user`
                user:
                  oneOf:
                    - type: object
                      properties:
                        id:
                          $ref: '#/components/schemas/idResponse'
                          description: The ID of the user.
                        object:
                          type: string
                          const: user
                          description: The user object type name.
                        name:
                          oneOf:
                            - type: string
                            - type: 'null'
                          description: The name of the user.
                        avatar_url:
                          oneOf:
                            - type: string
                            - type: 'null'
                          description: The avatar URL of the user.
                        type:
                          type: string
                          const: person
                          description: The type of the user.
                        person:
                          type: object
                          properties:
                            email:
                              type: string
                              description: The email of the person.
                          additionalProperties: false
                          description: The person info of the user.
                      additionalProperties: false
                      required:
                        - id
                        - object
                        - name
                        - avatar_url
                        - type
                        - person
                    - $ref: '#/components/schemas/partialUserObjectResponse'
                  description: >-
                    Details about the owner of the bot, when the `type` of the
                    owner is `user`. This means the bot is for a integration.
              additionalProperties: false
              required:
                - type
                - user
              title: User
            - type: object
              properties:
                type:
                  type: string
                  const: workspace
                  description: Always `workspace`
                workspace:
                  type: boolean
                  const: true
                  description: >-
                    Details about the owner of the bot, when the `type` of the
                    owner is `workspace`. This means the bot is for an internal
                    integration.
              additionalProperties: false
              required:
                - type
                - workspace
              title: Workspace
          description: Details about the owner of the bot.
        workspace_id:
          type: string
          description: The ID of the bot's workspace.
        workspace_limits:
          type: object
          properties:
            max_file_upload_size_in_bytes:
              type: integer
              minimum: 0
              description: The maximum allowable size of a file upload, in bytes
          additionalProperties: false
          required:
            - max_file_upload_size_in_bytes
          description: Limits and restrictions that apply to the bot's workspace
        workspace_name:
          oneOf:
            - type: string
            - type: 'null'
          description: The name of the bot's workspace.
      additionalProperties: false
      required:
        - owner
        - workspace_id
        - workspace_limits
        - workspace_name
    annotationResponse:
      type: object
      properties:
        bold:
          type: boolean
        italic:
          type: boolean
        strikethrough:
          type: boolean
        underline:
          type: boolean
        code:
          type: boolean
        color:
          $ref: '#/components/schemas/apiColor'
      additionalProperties: false
      required:
        - bold
        - italic
        - strikethrough
        - underline
        - code
        - color
    userValueResponse:
      oneOf:
        - $ref: '#/components/schemas/partialUserObjectResponse'
        - $ref: '#/components/schemas/userObjectResponse'
    linkPreviewMentionResponse:
      type: object
      properties:
        url:
          type: string
          description: The URL of the link preview mention.
      additionalProperties: false
      required:
        - url
    linkMentionResponse:
      type: object
      properties:
        href:
          type: string
          description: The href of the link mention.
        title:
          type: string
          description: The title of the link.
        description:
          type: string
          description: The description of the link.
        link_author:
          type: string
          description: The author of the link.
        link_provider:
          type: string
          description: The provider of the link.
        thumbnail_url:
          type: string
          description: The thumbnail URL of the link.
        icon_url:
          type: string
          description: The icon URL of the link.
        iframe_url:
          type: string
          description: The iframe URL of the link.
        height:
          type: integer
          description: The height of the link preview iframe.
        padding:
          type: integer
          description: The padding of the link preview iframe.
        padding_top:
          type: integer
          description: The top padding of the link preview iframe.
      additionalProperties: false
      required:
        - href
    templateMentionResponse:
      oneOf:
        - $ref: '#/components/schemas/templateMentionDateTemplateMentionResponse'
        - $ref: '#/components/schemas/templateMentionUserTemplateMentionResponse'
    customEmojiResponse:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the custom emoji.
        name:
          type: string
          description: The name of the custom emoji.
        url:
          type: string
          description: The URL of the custom emoji.
      additionalProperties: false
      required:
        - id
        - name
        - url
    apiColor:
      type: string
      enum:
        - default
        - gray
        - brown
        - orange
        - yellow
        - green
        - blue
        - purple
        - pink
        - red
        - default_background
        - gray_background
        - brown_background
        - orange_background
        - yellow_background
        - green_background
        - blue_background
        - purple_background
        - pink_background
        - red_background
      description: >-
        One of: `default`, `gray`, `brown`, `orange`, `yellow`, `green`, `blue`,
        `purple`, `pink`, `red`, `default_background`, `gray_background`,
        `brown_background`, `orange_background`, `yellow_background`,
        `green_background`, `blue_background`, `purple_background`,
        `pink_background`, `red_background`
    templateMentionDateTemplateMentionResponse:
      type: object
      properties:
        type:
          type: string
          const: template_mention_date
          description: Always `template_mention_date`
        template_mention_date:
          type: string
          enum:
            - today
            - now
          description: The date of the template mention.
      additionalProperties: false
      required:
        - type
        - template_mention_date
      title: Template Mention Date
    templateMentionUserTemplateMentionResponse:
      type: object
      properties:
        type:
          type: string
          const: template_mention_user
          description: Always `template_mention_user`
        template_mention_user:
          type: string
          const: me
          description: The user of the template mention.
      additionalProperties: false
      required:
        - type
        - template_mention_user
      title: Template Mention User
  parameters:
    notionVersion:
      name: Notion-Version
      in: header
      required: true
      schema:
        enum:
          - '2025-09-03'
      description: >-
        The [API version](/reference/versioning) to use for this request. The
        latest version is `2025-09-03`.
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer

````