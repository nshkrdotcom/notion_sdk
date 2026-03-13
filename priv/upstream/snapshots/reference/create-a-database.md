> ## Documentation Index
> Fetch the complete documentation index at: https://developers.notion.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Create a database

<Danger>
  **Deprecated as of version 2025-09-03**

  This page describes the API for versions up to and including `2022-06-28`. In the new `2025-09-03` version, the concepts of databases and data sources were split up, as described in [Upgrading to 2025-09-03](/guides/get-started/upgrade-guide-2025-09-03).

  Refer to the new APIs instead:

  * [Create a database](/reference/database-create)
  * [Create a data source](/reference/create-a-data-source)
</Danger>

Creates a database as a subpage in the specified parent page, with the specified `properties` schema. Currently, the parent of a new database must be a Notion page or a [wiki database](https://www.notion.so/help/wikis-and-verified-pages).

<Info>
  **Integration capabilities**

  This endpoint requires an integration to have insert content capabilities. Attempting to call this API without insert content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](/reference/capabilities).
</Info>

<Warning>
  **Limitations**

  Creating new `status` database properties is currently not supported.
</Warning>

### Errors

Returns a 404 if the specified parent page does not exist, or if the integration does not have access to the parent page.

Returns a 400 if the request is incorrectly formatted, or a 429 HTTP response if the request exceeds the [request limits](/reference/request-limits).

*Note: Each Public API endpoint can return several possible error codes. See the [Error codes section](/reference/status-codes#error-codes) of the Status codes documentation for more information.*


## OpenAPI

````yaml post /v1/databases
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
  /v1/databases:
    post:
      tags:
        - Databases
      summary: Create a database
      operationId: create-database
      parameters:
        - $ref: '#/components/parameters/notionVersion'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                parent:
                  allOf:
                    - type: object
                      properties:
                        type:
                          type: string
                          enum:
                            - page_id
                            - workspace
                          description: The type of parent.
                      required:
                        - type
                    - oneOf:
                        - type: object
                          properties:
                            type:
                              type: string
                              const: page_id
                              description: Always `page_id`
                            page_id:
                              $ref: '#/components/schemas/idRequest'
                          required:
                            - type
                            - page_id
                          title: Page Id
                        - type: object
                          properties:
                            type:
                              type: string
                              const: workspace
                              description: Always `workspace`
                            workspace:
                              type: boolean
                              const: true
                              description: Always `true`
                          required:
                            - type
                            - workspace
                          title: Workspace
                  description: >-
                    The parent page or workspace where the database will be
                    created.
                title:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                  description: The title of the database.
                description:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                  description: The description of the database.
                is_inline:
                  type: boolean
                  description: >-
                    Whether the database should be displayed inline in the
                    parent page. Defaults to false.
                initial_data_source:
                  $ref: '#/components/schemas/initialDataSourceRequest'
                  description: Initial data source configuration for the database.
                icon:
                  $ref: '#/components/schemas/pageIconRequest'
                  description: The icon for the database.
                cover:
                  $ref: '#/components/schemas/pageCoverRequest'
                  description: The cover image for the database.
              required:
                - parent
      responses:
        '200':
          description: ''
          content:
            application/json:
              schema:
                oneOf:
                  - $ref: '#/components/schemas/partialDatabaseObjectResponse'
                  - $ref: '#/components/schemas/databaseObjectResponse'
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

            const response = await notion.databases.create({
              parent: {
                type: "page_id",
                page_id: "b55c9c91-384d-452b-81db-d1ef79372b75"
              },
              title: [{ text: { content: "My Database" } }]
            })
components:
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
  schemas:
    idRequest:
      type: string
    richTextItemRequest:
      allOf:
        - $ref: '#/components/schemas/richTextItemRequestCommon'
        - oneOf:
            - $ref: '#/components/schemas/textRichTextItemRequest'
            - $ref: '#/components/schemas/mentionRichTextItemRequest'
            - $ref: '#/components/schemas/equationRichTextItemRequest'
    initialDataSourceRequest:
      type: object
      properties:
        properties:
          type: object
          additionalProperties:
            $ref: '#/components/schemas/propertyConfigurationRequest'
          description: >-
            Property schema for the initial data source, if you'd like to create
            one.
    pageIconRequest:
      oneOf:
        - $ref: '#/components/schemas/fileUploadPageIconRequest'
        - $ref: '#/components/schemas/emojiPageIconRequest'
        - $ref: '#/components/schemas/externalPageIconRequest'
        - $ref: '#/components/schemas/customEmojiPageIconRequest'
    pageCoverRequest:
      oneOf:
        - $ref: '#/components/schemas/fileUploadPageCoverRequest'
        - $ref: '#/components/schemas/externalPageCoverRequest'
    partialDatabaseObjectResponse:
      type: object
      properties:
        object:
          type: string
          const: database
          description: The database object type name.
        id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the database.
      additionalProperties: false
      required:
        - object
        - id
    databaseObjectResponse:
      type: object
      properties:
        object:
          type: string
          const: database
          description: The database object type name.
        id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the database.
        title:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
          description: The title of the database.
        description:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
          description: The description of the database.
        parent:
          $ref: '#/components/schemas/parentOfDatabaseResponse'
          description: >-
            The parent of the database. This is typically a page, block, or
            workspace, but can be another database in the case of wikis.
        is_inline:
          type: boolean
          description: Whether the database is inline.
        in_trash:
          type: boolean
          description: Whether the database is in the trash.
        is_locked:
          type: boolean
          description: Whether the database is locked from editing in the Notion app UI.
        created_time:
          type: string
          format: date-time
          description: The time when the database was created.
        last_edited_time:
          type: string
          format: date-time
          description: The time when the database was last edited.
        data_sources:
          type: array
          items:
            $ref: '#/components/schemas/dataSourceReferenceResponse'
          maxItems: 100
          description: The data sources of the database.
        icon:
          oneOf:
            - $ref: '#/components/schemas/pageIconResponse'
            - type: 'null'
          description: The icon of the database.
        cover:
          oneOf:
            - $ref: '#/components/schemas/pageCoverResponse'
            - type: 'null'
          description: The cover of the database.
        url:
          type: string
          description: The URL of the database.
        public_url:
          oneOf:
            - type: string
            - type: 'null'
          description: The public URL of the database if it is publicly accessible.
      additionalProperties: false
      required:
        - object
        - id
        - title
        - description
        - parent
        - is_inline
        - in_trash
        - is_locked
        - created_time
        - last_edited_time
        - data_sources
        - icon
        - cover
        - url
        - public_url
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
    richTextItemRequestCommon:
      type: object
      properties:
        annotations:
          $ref: '#/components/schemas/annotationRequest'
          description: >-
            All rich text objects contain an annotations object that sets the
            styling for the rich text.
    textRichTextItemRequest:
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
                  required:
                    - url
                - type: 'null'
              description: >-
                An object with information about any inline link in this text,
                if included.
          additionalProperties: false
          required:
            - content
          description: >-
            If a rich text object's type value is `text`, then the corresponding
            text field contains an object including the text content and any
            inline link.
      required:
        - text
      title: Text
    mentionRichTextItemRequest:
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
                  $ref: '#/components/schemas/partialUserObjectRequest'
                  description: Details of the user mention.
              required:
                - user
              title: User
            - type: object
              properties:
                type:
                  type: string
                  const: date
                  description: Always `date`
                date:
                  $ref: '#/components/schemas/dateRequest'
                  description: Details of the date mention.
              required:
                - date
              title: Date
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
                      $ref: '#/components/schemas/idRequest'
                      description: The ID of the page in the mention.
                  required:
                    - id
                  description: Details of the page mention.
              required:
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
                      $ref: '#/components/schemas/idRequest'
                      description: The ID of the database in the mention.
                  required:
                    - id
                  description: Details of the database mention.
              required:
                - database
              title: Database
            - type: object
              properties:
                type:
                  type: string
                  const: template_mention
                  description: Always `template_mention`
                template_mention:
                  $ref: '#/components/schemas/templateMentionRequest'
                  description: Details of the template mention.
              required:
                - template_mention
              title: Template Mention
            - type: object
              properties:
                type:
                  type: string
                  const: custom_emoji
                  description: Always `custom_emoji`
                custom_emoji:
                  type: object
                  properties:
                    id:
                      $ref: '#/components/schemas/idRequest'
                      description: The ID of the custom emoji.
                    name:
                      type: string
                      description: The name of the custom emoji.
                    url:
                      type: string
                      description: The URL of the custom emoji.
                  required:
                    - id
                  description: Details of the custom emoji mention.
              required:
                - custom_emoji
              title: Custom Emoji
          description: >-
            Mention objects represent an inline mention of a database, date,
            link preview mention, page, template mention, or user. A mention is
            created in the Notion UI when a user types `@` followed by the name
            of the reference.
      required:
        - mention
      title: Mention
    equationRichTextItemRequest:
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
          required:
            - expression
          description: >-
            Notion supports inline LaTeX equations as rich text objects with a
            type value of `equation`.
      required:
        - equation
      title: Equation
    propertyConfigurationRequest:
      allOf:
        - $ref: '#/components/schemas/propertyConfigurationRequestCommon'
        - oneOf:
            - $ref: '#/components/schemas/numberPropertyConfigurationRequest'
            - $ref: '#/components/schemas/formulaPropertyConfigurationRequest'
            - $ref: '#/components/schemas/selectPropertyConfigurationRequest'
            - $ref: '#/components/schemas/multiSelectPropertyConfigurationRequest'
            - $ref: '#/components/schemas/statusPropertyConfigurationRequest'
            - $ref: '#/components/schemas/relationPropertyConfigurationRequest'
            - $ref: '#/components/schemas/rollupPropertyConfigurationRequest'
            - $ref: '#/components/schemas/uniqueIdPropertyConfigurationRequest'
            - $ref: '#/components/schemas/titlePropertyConfigurationRequest'
            - $ref: '#/components/schemas/richTextPropertyConfigurationRequest'
            - $ref: '#/components/schemas/urlPropertyConfigurationRequest'
            - $ref: '#/components/schemas/peoplePropertyConfigurationRequest'
            - $ref: '#/components/schemas/filesPropertyConfigurationRequest'
            - $ref: '#/components/schemas/emailPropertyConfigurationRequest'
            - $ref: '#/components/schemas/phoneNumberPropertyConfigurationRequest'
            - $ref: '#/components/schemas/datePropertyConfigurationRequest'
            - $ref: '#/components/schemas/checkboxPropertyConfigurationRequest'
            - $ref: '#/components/schemas/createdByPropertyConfigurationRequest'
            - $ref: '#/components/schemas/createdTimePropertyConfigurationRequest'
            - $ref: '#/components/schemas/lastEditedByPropertyConfigurationRequest'
            - $ref: '#/components/schemas/lastEditedTimePropertyConfigurationRequest'
            - $ref: '#/components/schemas/buttonPropertyConfigurationRequest'
            - $ref: '#/components/schemas/locationPropertyConfigurationRequest'
            - $ref: '#/components/schemas/verificationPropertyConfigurationRequest'
            - $ref: '#/components/schemas/lastVisitedTimePropertyConfigurationRequest'
            - $ref: '#/components/schemas/placePropertyConfigurationRequest'
    fileUploadPageIconRequest:
      type: object
      properties:
        type:
          type: string
          const: file_upload
          description: Always `file_upload`
        file_upload:
          type: object
          properties:
            id:
              type: string
              description: ID of a FileUpload object that has the status `uploaded`.
          required:
            - id
      required:
        - file_upload
      title: File Upload
    emojiPageIconRequest:
      type: object
      properties:
        type:
          type: string
          const: emoji
          description: Always `emoji`
        emoji:
          $ref: '#/components/schemas/emojiRequest'
          description: An emoji character.
      required:
        - emoji
      title: Emoji
    externalPageIconRequest:
      type: object
      properties:
        type:
          type: string
          const: external
          description: Always `external`
        external:
          type: object
          properties:
            url:
              type: string
              description: The URL of the external file.
          required:
            - url
      required:
        - external
      title: External
    customEmojiPageIconRequest:
      type: object
      properties:
        type:
          type: string
          const: custom_emoji
          description: Always `custom_emoji`
        custom_emoji:
          type: object
          properties:
            id:
              $ref: '#/components/schemas/idRequest'
              description: The ID of the custom emoji.
            name:
              type: string
              description: The name of the custom emoji.
            url:
              type: string
              description: The URL of the custom emoji.
          required:
            - id
      required:
        - custom_emoji
      title: Custom Emoji
    fileUploadPageCoverRequest:
      type: object
      properties:
        type:
          type: string
          const: file_upload
          description: Always `file_upload`
        file_upload:
          type: object
          properties:
            id:
              type: string
              description: ID of a FileUpload object that has the status `uploaded`.
          required:
            - id
          description: The file upload for the cover.
      required:
        - file_upload
      title: File Upload
    externalPageCoverRequest:
      type: object
      properties:
        type:
          type: string
          const: external
          description: Always `external`
        external:
          type: object
          properties:
            url:
              type: string
              description: The URL of the external file.
          required:
            - url
          description: External URL for the cover.
      required:
        - external
      title: External
    idResponse:
      type: string
      format: uuid
    richTextItemResponse:
      allOf:
        - $ref: '#/components/schemas/richTextItemResponseCommon'
        - oneOf:
            - $ref: '#/components/schemas/textRichTextItemResponse'
            - $ref: '#/components/schemas/mentionRichTextItemResponse'
            - $ref: '#/components/schemas/equationRichTextItemResponse'
    parentOfDatabaseResponse:
      oneOf:
        - $ref: '#/components/schemas/pageIdParentForBlockBasedObjectResponse'
        - $ref: '#/components/schemas/workspaceParentForBlockBasedObjectResponse'
        - $ref: '#/components/schemas/databaseParentResponse'
        - $ref: '#/components/schemas/blockIdParentForBlockBasedObjectResponse'
    dataSourceReferenceResponse:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the data source.
        name:
          type: string
          description: The name of the data source.
      additionalProperties: false
      required:
        - id
        - name
    pageIconResponse:
      oneOf:
        - $ref: '#/components/schemas/emojiPageIconResponse'
        - $ref: '#/components/schemas/filePageIconResponse'
        - $ref: '#/components/schemas/externalPageIconResponse'
        - $ref: '#/components/schemas/customEmojiPageIconResponse'
    pageCoverResponse:
      oneOf:
        - $ref: '#/components/schemas/filePageCoverResponse'
        - $ref: '#/components/schemas/externalPageCoverResponse'
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
    annotationRequest:
      type: object
      properties:
        bold:
          type: boolean
          description: Whether the text is formatted as bold.
        italic:
          type: boolean
          description: Whether the text is formatted as italic.
        strikethrough:
          type: boolean
          description: Whether the text is formatted with a strikethrough.
        underline:
          type: boolean
          description: Whether the text is formatted with an underline.
        code:
          type: boolean
          description: Whether the text is formatted as code.
        color:
          $ref: '#/components/schemas/apiColor'
          description: The color of the text.
    partialUserObjectRequest:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/idRequest'
          description: The ID of the user.
        object:
          type: string
          const: user
          description: The user object type name.
      required:
        - id
    dateRequest:
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
          description: >-
            The time zone of the date object, if any. E.g. America/Los_Angeles,
            Europe/London, etc.
      additionalProperties: false
      required:
        - start
    templateMentionRequest:
      oneOf:
        - $ref: '#/components/schemas/templateMentionDateTemplateMentionRequest'
        - $ref: '#/components/schemas/templateMentionUserTemplateMentionRequest'
    propertyConfigurationRequestCommon:
      type: object
      properties:
        description:
          oneOf:
            - $ref: '#/components/schemas/propertyDescriptionRequest'
            - type: 'null'
          description: The description of the property.
    numberPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: number
          description: Always `number`
        number:
          type: object
          properties:
            format:
              $ref: '#/components/schemas/numberFormat'
      required:
        - number
      title: Number
    formulaPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: formula
          description: Always `formula`
        formula:
          type: object
          properties:
            expression:
              type: string
      required:
        - formula
      title: Formula
    selectPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: select
          description: Always `select`
        select:
          type: object
          properties:
            options:
              type: array
              items:
                type: object
                properties:
                  name:
                    type: string
                  color:
                    $ref: '#/components/schemas/selectColor'
                  description:
                    oneOf:
                      - type: string
                      - type: 'null'
                required:
                  - name
              maxItems: 100
      required:
        - select
      title: Select
    multiSelectPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: multi_select
          description: Always `multi_select`
        multi_select:
          type: object
          properties:
            options:
              type: array
              items:
                type: object
                properties:
                  name:
                    type: string
                  color:
                    $ref: '#/components/schemas/selectColor'
                  description:
                    oneOf:
                      - type: string
                      - type: 'null'
                required:
                  - name
              maxItems: 100
      required:
        - multi_select
      title: Multi Select
    statusPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: status
          description: Always `status`
        status:
          $ref: '#/components/schemas/emptyObject'
      required:
        - status
      title: Status
    relationPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: relation
          description: Always `relation`
        relation:
          allOf:
            - type: object
              properties:
                data_source_id:
                  $ref: '#/components/schemas/idRequest'
              required:
                - data_source_id
            - oneOf:
                - type: object
                  properties:
                    type:
                      type: string
                      const: single_property
                      description: Always `single_property`
                    single_property:
                      $ref: '#/components/schemas/emptyObject'
                  required:
                    - single_property
                  title: Single Property
                - type: object
                  properties:
                    type:
                      type: string
                      const: dual_property
                      description: Always `dual_property`
                    dual_property:
                      type: object
                      properties:
                        synced_property_id:
                          type: string
                        synced_property_name:
                          type: string
                  required:
                    - dual_property
                  title: Dual Property
      required:
        - relation
      title: Relation
    rollupPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: rollup
          description: Always `rollup`
        rollup:
          allOf:
            - type: object
              properties:
                function:
                  $ref: '#/components/schemas/rollupFunction'
                  description: >-
                    The function to use for the rollup, e.g. count,
                    count_values, percent_not_empty, max.
              required:
                - function
            - oneOf:
                - type: object
                  properties:
                    relation_property_name:
                      type: string
                    rollup_property_name:
                      type: string
                  required:
                    - relation_property_name
                    - rollup_property_name
                - type: object
                  properties:
                    relation_property_id:
                      type: string
                    rollup_property_name:
                      type: string
                  required:
                    - relation_property_id
                    - rollup_property_name
                - type: object
                  properties:
                    relation_property_name:
                      type: string
                    rollup_property_id:
                      type: string
                  required:
                    - relation_property_name
                    - rollup_property_id
                - type: object
                  properties:
                    relation_property_id:
                      type: string
                    rollup_property_id:
                      type: string
                  required:
                    - relation_property_id
                    - rollup_property_id
      required:
        - rollup
      title: Rollup
    uniqueIdPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: unique_id
          description: Always `unique_id`
        unique_id:
          type: object
          properties:
            prefix:
              oneOf:
                - type: string
                - type: 'null'
      required:
        - unique_id
      title: Unique Id
    titlePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: title
          description: Always `title`
        title:
          $ref: '#/components/schemas/emptyObject'
      required:
        - title
      title: Title
    richTextPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: rich_text
          description: Always `rich_text`
        rich_text:
          $ref: '#/components/schemas/emptyObject'
      required:
        - rich_text
      title: Rich Text
    urlPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: url
          description: Always `url`
        url:
          $ref: '#/components/schemas/emptyObject'
      required:
        - url
      title: Url
    peoplePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: people
          description: Always `people`
        people:
          $ref: '#/components/schemas/emptyObject'
      required:
        - people
      title: People
    filesPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: files
          description: Always `files`
        files:
          $ref: '#/components/schemas/emptyObject'
      required:
        - files
      title: Files
    emailPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: email
          description: Always `email`
        email:
          $ref: '#/components/schemas/emptyObject'
      required:
        - email
      title: Email
    phoneNumberPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: phone_number
          description: Always `phone_number`
        phone_number:
          $ref: '#/components/schemas/emptyObject'
      required:
        - phone_number
      title: Phone Number
    datePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: date
          description: Always `date`
        date:
          $ref: '#/components/schemas/emptyObject'
      required:
        - date
      title: Date
    checkboxPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: checkbox
          description: Always `checkbox`
        checkbox:
          $ref: '#/components/schemas/emptyObject'
      required:
        - checkbox
      title: Checkbox
    createdByPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: created_by
          description: Always `created_by`
        created_by:
          $ref: '#/components/schemas/emptyObject'
      required:
        - created_by
      title: Created By
    createdTimePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: created_time
          description: Always `created_time`
        created_time:
          $ref: '#/components/schemas/emptyObject'
      required:
        - created_time
      title: Created Time
    lastEditedByPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: last_edited_by
          description: Always `last_edited_by`
        last_edited_by:
          $ref: '#/components/schemas/emptyObject'
      required:
        - last_edited_by
      title: Last Edited By
    lastEditedTimePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: last_edited_time
          description: Always `last_edited_time`
        last_edited_time:
          $ref: '#/components/schemas/emptyObject'
      required:
        - last_edited_time
      title: Last Edited Time
    buttonPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: button
          description: Always `button`
        button:
          $ref: '#/components/schemas/emptyObject'
      required:
        - button
      title: Button
    locationPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: location
          description: Always `location`
        location:
          $ref: '#/components/schemas/emptyObject'
      required:
        - location
      title: Location
    verificationPropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: verification
          description: Always `verification`
        verification:
          $ref: '#/components/schemas/emptyObject'
      required:
        - verification
      title: Verification
    lastVisitedTimePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: last_visited_time
          description: Always `last_visited_time`
        last_visited_time:
          $ref: '#/components/schemas/emptyObject'
      required:
        - last_visited_time
      title: Last Visited Time
    placePropertyConfigurationRequest:
      type: object
      properties:
        type:
          type: string
          const: place
          description: Always `place`
        place:
          $ref: '#/components/schemas/emptyObject'
      required:
        - place
      title: Place
    emojiRequest:
      type: string
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
    pageIdParentForBlockBasedObjectResponse:
      type: object
      properties:
        type:
          type: string
          const: page_id
          description: The parent type.
        page_id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the parent page.
      additionalProperties: false
      required:
        - type
        - page_id
    workspaceParentForBlockBasedObjectResponse:
      type: object
      properties:
        type:
          type: string
          const: workspace
          description: The parent type.
        workspace:
          type: boolean
          const: true
          description: Always true for workspace parent.
      additionalProperties: false
      required:
        - type
        - workspace
    databaseParentResponse:
      type: object
      properties:
        type:
          type: string
          const: database_id
          description: The parent type.
        database_id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the parent database.
      additionalProperties: false
      required:
        - type
        - database_id
    blockIdParentForBlockBasedObjectResponse:
      type: object
      properties:
        type:
          type: string
          const: block_id
          description: The parent type.
        block_id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the parent block.
      additionalProperties: false
      required:
        - type
        - block_id
    emojiPageIconResponse:
      type: object
      properties:
        type:
          type: string
          const: emoji
          description: Type of icon. In this case, an emoji.
        emoji:
          $ref: '#/components/schemas/emojiRequest'
          description: The emoji character used as the icon.
      additionalProperties: false
      required:
        - type
        - emoji
      title: Emoji
    filePageIconResponse:
      type: object
      properties:
        type:
          type: string
          const: file
          description: Type of icon. In this case, a file.
        file:
          $ref: '#/components/schemas/internalFileResponse'
          description: The file URL for the icon.
      additionalProperties: false
      required:
        - type
        - file
      title: File
    externalPageIconResponse:
      type: object
      properties:
        type:
          type: string
          const: external
          description: Type of icon. In this case, an external URL.
        external:
          type: object
          properties:
            url:
              type: string
              description: The URL of the external file or resource.
          additionalProperties: false
          required:
            - url
          description: The external URL for the icon.
      additionalProperties: false
      required:
        - type
        - external
      title: External
    customEmojiPageIconResponse:
      type: object
      properties:
        type:
          type: string
          const: custom_emoji
          description: Type of icon. In this case, a custom emoji.
        custom_emoji:
          $ref: '#/components/schemas/customEmojiResponse'
          description: The custom emoji details for the icon.
      additionalProperties: false
      required:
        - type
        - custom_emoji
      title: Custom Emoji
    filePageCoverResponse:
      type: object
      properties:
        type:
          type: string
          const: file
          description: Type of cover. In this case, a file.
        file:
          $ref: '#/components/schemas/internalFileResponse'
          description: The file URL for the cover.
      additionalProperties: false
      required:
        - type
        - file
      title: File
    externalPageCoverResponse:
      type: object
      properties:
        type:
          type: string
          const: external
          description: Type of cover. In this case, an external URL.
        external:
          type: object
          properties:
            url:
              type: string
              description: The URL of the external file or resource.
          additionalProperties: false
          required:
            - url
          description: The external URL for the cover.
      additionalProperties: false
      required:
        - type
        - external
      title: External
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
    timeZoneRequest:
      type: string
    templateMentionDateTemplateMentionRequest:
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
        - template_mention_date
      title: Template Mention Date
    templateMentionUserTemplateMentionRequest:
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
        - template_mention_user
      title: Template Mention User
    propertyDescriptionRequest:
      type: string
      minLength: 1
      maxLength: 280
    numberFormat:
      type: string
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
    emptyObject:
      type: object
      properties: {}
      additionalProperties: false
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
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer

````