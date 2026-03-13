> ## Documentation Index
> Fetch the complete documentation index at: https://developers.notion.com/llms.txt
> Use this file to discover all available pages before exploring further.

> Creates and appends new children blocks to the parent `block_id` specified. Blocks can be parented by other blocks, pages, or databases.

# Append block children

Returns a paginated list of newly created first level children [block objects](/reference/block).

Existing blocks cannot be moved using this endpoint. Once a block is appended as a child, it can't be moved elsewhere via the API.

For blocks that allow children, we allow up to **two** levels of nesting in a single request.

There is a limit of **100 block children** that can be appended by a single API request. Arrays of block children longer than 100 will result in an error.

### Controlling insert position

By default, blocks are appended to the end of the parent block's children. Use the `position` parameter to insert blocks at a specific location:

| Position type                                                      | Description                                                   |
| ------------------------------------------------------------------ | ------------------------------------------------------------- |
| `{ "type": "end" }`                                                | Insert at the end of the parent's children (default behavior) |
| `{ "type": "start" }`                                              | Insert at the beginning of the parent's children              |
| `{ "type": "after_block", "after_block": { "id": "<block_id>" } }` | Insert after the specified block                              |

<CodeGroup>
  ```json Insert at start theme={null}
  {
    "children": [/* blocks */],
    "position": { "type": "start" }
  }
  ```

  ```json Insert after specific block theme={null}
  {
    "children": [/* blocks */],
    "position": {
      "type": "after_block",
      "after_block": { "id": "12345678-1234-1234-1234-123456789abc" }
    }
  }
  ```
</CodeGroup>

<Warning>
  **Deprecated parameter**

  The `after` parameter is deprecated. Use the `position` parameter instead, which provides more flexibility including inserting at the start of the children list.

  If you're currently using `after`, migrate to `position` with type `after_block`:

  * **Before:** `{ "children": [...], "after": "<block_id>" }`
  * **After:** `{ "children": [...], "position": { "type": "after_block", "after_block": { "id": "<block_id>" } } }`

  You cannot specify both `after` and `position` in the same request.
</Warning>

<Info>
  **Integration capabilities**

  This endpoint requires an integration to have insert content capabilities. Attempting to call this API without insert content capabilities will return an HTTP response with a 403 status code. For more information on integration capabilities, see the [capabilities guide](/reference/capabilities).
</Info>

### Errors

Returns a 404 HTTP response if the block specified by `id` doesn't exist, or if the integration doesn't have access to the block.

Returns a 400 or 429 HTTP response if the request exceeds the [request limits](/reference/request-limits).

*Note: Each Public API endpoint can return several possible error codes. To see a full description of each type of error code, see the [Error codes section](/reference/status-codes#error-codes) of the Status codes documentation.*


## OpenAPI

````yaml patch /v1/blocks/{block_id}/children
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
  /v1/blocks/{block_id}/children:
    patch:
      tags:
        - Blocks
      summary: Append block children
      operationId: patch-block-children
      parameters:
        - name: block_id
          in: path
          required: true
          schema:
            $ref: '#/components/schemas/idRequest'
        - $ref: '#/components/parameters/notionVersion'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                children:
                  type: array
                  items:
                    $ref: '#/components/schemas/blockObjectRequest'
                  maxItems: 100
                position:
                  $ref: '#/components/schemas/contentPositionSchema'
              additionalProperties: false
              required:
                - children
      responses:
        '200':
          description: ''
          content:
            application/json:
              schema:
                title: Block
                type: object
                properties:
                  type:
                    type: string
                    const: block
                  block:
                    $ref: '#/components/schemas/emptyObject'
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
                      anyOf:
                        - $ref: '#/components/schemas/partialBlockObjectResponse'
                        - $ref: '#/components/schemas/blockObjectResponse'
                required:
                  - type
                  - block
                  - object
                  - next_cursor
                  - has_more
                  - results
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

            const response = await notion.blocks.children.append({
              block_id: "c02fc1d3-db8b-45c5-a222-27595b15aea7",
              children: [
                {
                  type: "paragraph",
                  paragraph: {
                    rich_text: [{ text: { content: "Hello, world!" } }]
                  }
                }
              ]
            })
components:
  schemas:
    idRequest:
      type: string
    blockObjectRequest:
      anyOf:
        - title: Embed
          type: object
          properties:
            embed:
              $ref: '#/components/schemas/mediaContentWithUrlAndCaptionRequest'
            type:
              type: string
              const: embed
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - embed
        - title: Bookmark
          type: object
          properties:
            bookmark:
              $ref: '#/components/schemas/mediaContentWithUrlAndCaptionRequest'
            type:
              type: string
              const: bookmark
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - bookmark
        - title: Image
          type: object
          properties:
            image:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: image
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - image
        - title: Video
          type: object
          properties:
            video:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: video
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - video
        - title: Pdf
          type: object
          properties:
            pdf:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: pdf
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - pdf
        - title: File
          type: object
          properties:
            file:
              $ref: '#/components/schemas/mediaContentWithFileNameAndCaptionRequest'
            type:
              type: string
              const: file
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - file
        - title: Audio
          type: object
          properties:
            audio:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: audio
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - audio
        - title: Code
          type: object
          properties:
            code:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                language:
                  $ref: '#/components/schemas/languageRequest'
                caption:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
                - language
            type:
              type: string
              const: code
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - code
        - title: Equation
          type: object
          properties:
            equation:
              $ref: '#/components/schemas/contentWithExpressionRequest'
            type:
              type: string
              const: equation
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - equation
        - title: Divider
          type: object
          properties:
            divider:
              $ref: '#/components/schemas/emptyObject'
            type:
              type: string
              const: divider
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - divider
        - title: Breadcrumb
          type: object
          properties:
            breadcrumb:
              $ref: '#/components/schemas/emptyObject'
            type:
              type: string
              const: breadcrumb
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - breadcrumb
        - title: Table Of Contents
          type: object
          properties:
            table_of_contents:
              type: object
              properties:
                color:
                  $ref: '#/components/schemas/apiColor'
              additionalProperties: false
            type:
              type: string
              const: table_of_contents
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table_of_contents
        - title: Link To Page
          type: object
          properties:
            link_to_page:
              anyOf:
                - title: Page Id
                  type: object
                  properties:
                    page_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: page_id
                  additionalProperties: false
                  required:
                    - page_id
                - title: Database Id
                  type: object
                  properties:
                    database_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: database_id
                  additionalProperties: false
                  required:
                    - database_id
                - title: Comment Id
                  type: object
                  properties:
                    comment_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: comment_id
                  additionalProperties: false
                  required:
                    - comment_id
            type:
              type: string
              const: link_to_page
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - link_to_page
        - title: Table Row
          type: object
          properties:
            table_row:
              $ref: '#/components/schemas/contentWithTableRowRequest'
            type:
              type: string
              const: table_row
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table_row
        - title: Table
          type: object
          properties:
            table:
              $ref: '#/components/schemas/tableRequestWithTableRowChildren'
            type:
              type: string
              const: table
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table
        - title: Column List
          type: object
          properties:
            column_list:
              $ref: '#/components/schemas/columnListRequest'
            type:
              type: string
              const: column_list
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - column_list
        - title: Column
          type: object
          properties:
            column:
              $ref: '#/components/schemas/columnWithChildrenRequest'
            type:
              type: string
              const: column
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - column
        - title: Heading 1
          type: object
          properties:
            heading_1:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                is_toggleable:
                  type: boolean
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: heading_1
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_1
        - title: Heading 2
          type: object
          properties:
            heading_2:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                is_toggleable:
                  type: boolean
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: heading_2
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_2
        - title: Heading 3
          type: object
          properties:
            heading_3:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                is_toggleable:
                  type: boolean
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: heading_3
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_3
        - title: Paragraph
          type: object
          properties:
            paragraph:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: paragraph
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - paragraph
        - title: Bulleted List Item
          type: object
          properties:
            bulleted_list_item:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: bulleted_list_item
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - bulleted_list_item
        - title: Numbered List Item
          type: object
          properties:
            numbered_list_item:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: numbered_list_item
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - numbered_list_item
        - title: Quote
          type: object
          properties:
            quote:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: quote
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - quote
        - title: To Do
          type: object
          properties:
            to_do:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
                checked:
                  type: boolean
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: to_do
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - to_do
        - title: Toggle
          type: object
          properties:
            toggle:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: toggle
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - toggle
        - title: Template
          type: object
          properties:
            template:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: template
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - template
        - title: Callout
          type: object
          properties:
            callout:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
                icon:
                  $ref: '#/components/schemas/pageIconRequest'
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: callout
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - callout
        - title: Synced Block
          type: object
          properties:
            synced_block:
              type: object
              properties:
                synced_from:
                  title: Block Id
                  type:
                    - object
                    - 'null'
                  properties:
                    block_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: block_id
                  additionalProperties: false
                  required:
                    - block_id
                children:
                  type: array
                  items:
                    $ref: >-
                      #/components/schemas/blockObjectWithSingleLevelOfChildrenRequest
                  maxItems: 100
              additionalProperties: false
              required:
                - synced_from
            type:
              type: string
              const: synced_block
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - synced_block
    contentPositionSchema:
      anyOf:
        - type: object
          properties:
            type:
              type: string
              const: after_block
            after_block:
              type: object
              properties:
                id:
                  $ref: '#/components/schemas/idRequest'
              required:
                - id
          required:
            - type
            - after_block
        - type: object
          properties:
            type:
              type: string
              const: start
          required:
            - type
        - type: object
          properties:
            type:
              type: string
              const: end
          required:
            - type
    emptyObject:
      type: object
      properties: {}
      additionalProperties: false
    partialBlockObjectResponse:
      type: object
      properties:
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
      required:
        - object
        - id
    blockObjectResponse:
      anyOf:
        - $ref: '#/components/schemas/paragraphBlockObjectResponse'
        - $ref: '#/components/schemas/heading1BlockObjectResponse'
        - $ref: '#/components/schemas/heading2BlockObjectResponse'
        - $ref: '#/components/schemas/heading3BlockObjectResponse'
        - $ref: '#/components/schemas/bulletedListItemBlockObjectResponse'
        - $ref: '#/components/schemas/numberedListItemBlockObjectResponse'
        - $ref: '#/components/schemas/quoteBlockObjectResponse'
        - $ref: '#/components/schemas/toDoBlockObjectResponse'
        - $ref: '#/components/schemas/toggleBlockObjectResponse'
        - $ref: '#/components/schemas/templateBlockObjectResponse'
        - $ref: '#/components/schemas/syncedBlockBlockObjectResponse'
        - $ref: '#/components/schemas/childPageBlockObjectResponse'
        - $ref: '#/components/schemas/childDatabaseBlockObjectResponse'
        - $ref: '#/components/schemas/equationBlockObjectResponse'
        - $ref: '#/components/schemas/codeBlockObjectResponse'
        - $ref: '#/components/schemas/calloutBlockObjectResponse'
        - $ref: '#/components/schemas/dividerBlockObjectResponse'
        - $ref: '#/components/schemas/breadcrumbBlockObjectResponse'
        - $ref: '#/components/schemas/tableOfContentsBlockObjectResponse'
        - $ref: '#/components/schemas/columnListBlockObjectResponse'
        - $ref: '#/components/schemas/columnBlockObjectResponse'
        - $ref: '#/components/schemas/linkToPageBlockObjectResponse'
        - $ref: '#/components/schemas/tableBlockObjectResponse'
        - $ref: '#/components/schemas/tableRowBlockObjectResponse'
        - $ref: '#/components/schemas/meetingNotesBlockObjectResponse'
        - $ref: '#/components/schemas/embedBlockObjectResponse'
        - $ref: '#/components/schemas/bookmarkBlockObjectResponse'
        - $ref: '#/components/schemas/imageBlockObjectResponse'
        - $ref: '#/components/schemas/videoBlockObjectResponse'
        - $ref: '#/components/schemas/pdfBlockObjectResponse'
        - $ref: '#/components/schemas/fileBlockObjectResponse'
        - $ref: '#/components/schemas/audioBlockObjectResponse'
        - $ref: '#/components/schemas/linkPreviewBlockObjectResponse'
        - $ref: '#/components/schemas/unsupportedBlockObjectResponse'
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
    mediaContentWithUrlAndCaptionRequest:
      type: object
      properties:
        url:
          type: string
        caption:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemRequest'
          maxItems: 100
      additionalProperties: false
      required:
        - url
    mediaContentWithFileAndCaptionRequest:
      anyOf:
        - title: External
          type: object
          properties:
            external:
              $ref: '#/components/schemas/externalFileRequest'
            type:
              type: string
              const: external
            caption:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemRequest'
              maxItems: 100
          additionalProperties: false
          required:
            - external
        - title: File Upload
          type: object
          properties:
            file_upload:
              $ref: '#/components/schemas/fileUploadIdRequest'
            type:
              type: string
              const: file_upload
            caption:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemRequest'
              maxItems: 100
          additionalProperties: false
          required:
            - file_upload
    mediaContentWithFileNameAndCaptionRequest:
      anyOf:
        - title: External
          type: object
          properties:
            external:
              $ref: '#/components/schemas/externalFileRequest'
            type:
              type: string
              const: external
            caption:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemRequest'
              maxItems: 100
            name:
              $ref: '#/components/schemas/stringRequest'
          additionalProperties: false
          required:
            - external
        - title: File Upload
          type: object
          properties:
            file_upload:
              $ref: '#/components/schemas/fileUploadIdRequest'
            type:
              type: string
              const: file_upload
            caption:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemRequest'
              maxItems: 100
            name:
              $ref: '#/components/schemas/stringRequest'
          additionalProperties: false
          required:
            - file_upload
    richTextItemRequest:
      allOf:
        - $ref: '#/components/schemas/richTextItemRequestCommon'
        - oneOf:
            - $ref: '#/components/schemas/textRichTextItemRequest'
            - $ref: '#/components/schemas/mentionRichTextItemRequest'
            - $ref: '#/components/schemas/equationRichTextItemRequest'
    languageRequest:
      type: string
      enum:
        - abap
        - abc
        - agda
        - arduino
        - ascii art
        - assembly
        - bash
        - basic
        - bnf
        - c
        - c#
        - c++
        - clojure
        - coffeescript
        - coq
        - css
        - dart
        - dhall
        - diff
        - docker
        - ebnf
        - elixir
        - elm
        - erlang
        - f#
        - flow
        - fortran
        - gherkin
        - glsl
        - go
        - graphql
        - groovy
        - haskell
        - hcl
        - html
        - idris
        - java
        - javascript
        - json
        - julia
        - kotlin
        - latex
        - less
        - lisp
        - livescript
        - llvm ir
        - lua
        - makefile
        - markdown
        - markup
        - matlab
        - mathematica
        - mermaid
        - nix
        - notion formula
        - objective-c
        - ocaml
        - pascal
        - perl
        - php
        - plain text
        - powershell
        - prolog
        - protobuf
        - purescript
        - python
        - r
        - racket
        - reason
        - ruby
        - rust
        - sass
        - scala
        - scheme
        - scss
        - shell
        - smalltalk
        - solidity
        - sql
        - swift
        - toml
        - typescript
        - vb.net
        - verilog
        - vhdl
        - visual basic
        - webassembly
        - xml
        - yaml
        - java/c/c++/c#
    contentWithExpressionRequest:
      type: object
      properties:
        expression:
          type: string
      additionalProperties: false
      required:
        - expression
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
    contentWithTableRowRequest:
      type: object
      properties:
        cells:
          type: array
          items:
            type: array
            items:
              $ref: '#/components/schemas/richTextItemRequest'
            maxItems: 100
          maxItems: 100
      additionalProperties: false
      required:
        - cells
    tableRequestWithTableRowChildren:
      type: object
      properties:
        table_width:
          type: integer
          minimum: 1
        children:
          type: array
          items:
            $ref: '#/components/schemas/tableRowRequest'
          maxItems: 100
          minItems: 1
        has_column_header:
          type: boolean
        has_row_header:
          type: boolean
      additionalProperties: false
      required:
        - table_width
        - children
    columnListRequest:
      type: object
      properties:
        children:
          type: array
          items:
            $ref: '#/components/schemas/columnBlockWithChildrenRequest'
          maxItems: 100
          minItems: 2
      additionalProperties: false
      required:
        - children
    columnWithChildrenRequest:
      type: object
      properties:
        children:
          type: array
          items:
            $ref: '#/components/schemas/blockObjectWithSingleLevelOfChildrenRequest'
          maxItems: 100
        width_ratio:
          description: >-
            Ratio between 0 and 1 of the width of this column relative to all
            columns in the list. If not provided, uses an equal width.
          examples:
            - 0.5
          type: number
          exclusiveMinimum: 0
          exclusiveMaximum: 1
      additionalProperties: false
      required:
        - children
    blockObjectWithSingleLevelOfChildrenRequest:
      anyOf:
        - title: Embed
          type: object
          properties:
            embed:
              $ref: '#/components/schemas/mediaContentWithUrlAndCaptionRequest'
            type:
              type: string
              const: embed
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - embed
        - title: Bookmark
          type: object
          properties:
            bookmark:
              $ref: '#/components/schemas/mediaContentWithUrlAndCaptionRequest'
            type:
              type: string
              const: bookmark
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - bookmark
        - title: Image
          type: object
          properties:
            image:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: image
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - image
        - title: Video
          type: object
          properties:
            video:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: video
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - video
        - title: Pdf
          type: object
          properties:
            pdf:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: pdf
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - pdf
        - title: File
          type: object
          properties:
            file:
              $ref: '#/components/schemas/mediaContentWithFileNameAndCaptionRequest'
            type:
              type: string
              const: file
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - file
        - title: Audio
          type: object
          properties:
            audio:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: audio
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - audio
        - title: Code
          type: object
          properties:
            code:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                language:
                  $ref: '#/components/schemas/languageRequest'
                caption:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
                - language
            type:
              type: string
              const: code
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - code
        - title: Equation
          type: object
          properties:
            equation:
              $ref: '#/components/schemas/contentWithExpressionRequest'
            type:
              type: string
              const: equation
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - equation
        - title: Divider
          type: object
          properties:
            divider:
              $ref: '#/components/schemas/emptyObject'
            type:
              type: string
              const: divider
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - divider
        - title: Breadcrumb
          type: object
          properties:
            breadcrumb:
              $ref: '#/components/schemas/emptyObject'
            type:
              type: string
              const: breadcrumb
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - breadcrumb
        - title: Table Of Contents
          type: object
          properties:
            table_of_contents:
              type: object
              properties:
                color:
                  $ref: '#/components/schemas/apiColor'
              additionalProperties: false
            type:
              type: string
              const: table_of_contents
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table_of_contents
        - title: Link To Page
          type: object
          properties:
            link_to_page:
              anyOf:
                - title: Page Id
                  type: object
                  properties:
                    page_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: page_id
                  additionalProperties: false
                  required:
                    - page_id
                - title: Database Id
                  type: object
                  properties:
                    database_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: database_id
                  additionalProperties: false
                  required:
                    - database_id
                - title: Comment Id
                  type: object
                  properties:
                    comment_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: comment_id
                  additionalProperties: false
                  required:
                    - comment_id
            type:
              type: string
              const: link_to_page
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - link_to_page
        - title: Table Row
          type: object
          properties:
            table_row:
              $ref: '#/components/schemas/contentWithTableRowRequest'
            type:
              type: string
              const: table_row
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table_row
        - title: Heading 1
          type: object
          properties:
            heading_1:
              $ref: >-
                #/components/schemas/headerContentWithSingleLevelOfChildrenRequest
            type:
              type: string
              const: heading_1
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_1
        - title: Heading 2
          type: object
          properties:
            heading_2:
              $ref: >-
                #/components/schemas/headerContentWithSingleLevelOfChildrenRequest
            type:
              type: string
              const: heading_2
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_2
        - title: Heading 3
          type: object
          properties:
            heading_3:
              $ref: >-
                #/components/schemas/headerContentWithSingleLevelOfChildrenRequest
            type:
              type: string
              const: heading_3
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_3
        - title: Paragraph
          type: object
          properties:
            paragraph:
              $ref: '#/components/schemas/contentWithSingleLevelOfChildrenRequest'
            type:
              type: string
              const: paragraph
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - paragraph
        - title: Bulleted List Item
          type: object
          properties:
            bulleted_list_item:
              $ref: '#/components/schemas/contentWithSingleLevelOfChildrenRequest'
            type:
              type: string
              const: bulleted_list_item
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - bulleted_list_item
        - title: Numbered List Item
          type: object
          properties:
            numbered_list_item:
              $ref: '#/components/schemas/contentWithSingleLevelOfChildrenRequest'
            type:
              type: string
              const: numbered_list_item
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - numbered_list_item
        - title: Quote
          type: object
          properties:
            quote:
              $ref: '#/components/schemas/contentWithSingleLevelOfChildrenRequest'
            type:
              type: string
              const: quote
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - quote
        - title: Table
          type: object
          properties:
            table:
              $ref: '#/components/schemas/tableRequestWithTableRowChildren'
            type:
              type: string
              const: table
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table
        - title: To Do
          type: object
          properties:
            to_do:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: '#/components/schemas/blockObjectRequestWithoutChildren'
                  maxItems: 100
                checked:
                  type: boolean
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: to_do
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - to_do
        - title: Toggle
          type: object
          properties:
            toggle:
              $ref: '#/components/schemas/contentWithSingleLevelOfChildrenRequest'
            type:
              type: string
              const: toggle
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - toggle
        - title: Template
          type: object
          properties:
            template:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                children:
                  type: array
                  items:
                    $ref: '#/components/schemas/blockObjectRequestWithoutChildren'
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: template
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - template
        - title: Callout
          type: object
          properties:
            callout:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                color:
                  $ref: '#/components/schemas/apiColor'
                children:
                  type: array
                  items:
                    $ref: '#/components/schemas/blockObjectRequestWithoutChildren'
                  maxItems: 100
                icon:
                  $ref: '#/components/schemas/pageIconRequest'
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: callout
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - callout
        - title: Synced Block
          type: object
          properties:
            synced_block:
              type: object
              properties:
                synced_from:
                  title: Block Id
                  type:
                    - object
                    - 'null'
                  properties:
                    block_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: block_id
                  additionalProperties: false
                  required:
                    - block_id
                children:
                  type: array
                  items:
                    $ref: '#/components/schemas/blockObjectRequestWithoutChildren'
                  maxItems: 100
              additionalProperties: false
              required:
                - synced_from
            type:
              type: string
              const: synced_block
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - synced_block
    pageIconRequest:
      oneOf:
        - $ref: '#/components/schemas/fileUploadPageIconRequest'
        - $ref: '#/components/schemas/emojiPageIconRequest'
        - $ref: '#/components/schemas/externalPageIconRequest'
        - $ref: '#/components/schemas/customEmojiPageIconRequest'
    paragraphBlockObjectResponse:
      title: Paragraph
      type: object
      properties:
        type:
          type: string
          const: paragraph
        paragraph:
          $ref: '#/components/schemas/contentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - paragraph
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    heading1BlockObjectResponse:
      title: Heading 1
      type: object
      properties:
        type:
          type: string
          const: heading_1
        heading_1:
          $ref: '#/components/schemas/headerContentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - heading_1
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    heading2BlockObjectResponse:
      title: Heading 2
      type: object
      properties:
        type:
          type: string
          const: heading_2
        heading_2:
          $ref: '#/components/schemas/headerContentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - heading_2
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    heading3BlockObjectResponse:
      title: Heading 3
      type: object
      properties:
        type:
          type: string
          const: heading_3
        heading_3:
          $ref: '#/components/schemas/headerContentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - heading_3
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    bulletedListItemBlockObjectResponse:
      title: Bulleted List Item
      type: object
      properties:
        type:
          type: string
          const: bulleted_list_item
        bulleted_list_item:
          $ref: '#/components/schemas/contentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - bulleted_list_item
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    numberedListItemBlockObjectResponse:
      title: Numbered List Item
      type: object
      properties:
        type:
          type: string
          const: numbered_list_item
        numbered_list_item:
          $ref: '#/components/schemas/contentWithRichTextAndColorAndListResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - numbered_list_item
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    quoteBlockObjectResponse:
      title: Quote
      type: object
      properties:
        type:
          type: string
          const: quote
        quote:
          $ref: '#/components/schemas/contentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - quote
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    toDoBlockObjectResponse:
      title: To Do
      type: object
      properties:
        type:
          type: string
          const: to_do
        to_do:
          type: object
          properties:
            rich_text:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemResponse'
              maxItems: 100
            color:
              $ref: '#/components/schemas/apiColor'
            checked:
              type: boolean
          required:
            - rich_text
            - color
            - checked
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - to_do
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    toggleBlockObjectResponse:
      title: Toggle
      type: object
      properties:
        type:
          type: string
          const: toggle
        toggle:
          $ref: '#/components/schemas/contentWithRichTextAndColorResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - toggle
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    templateBlockObjectResponse:
      title: Template
      type: object
      properties:
        type:
          type: string
          const: template
        template:
          type: object
          properties:
            rich_text:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemResponse'
              maxItems: 100
          required:
            - rich_text
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - template
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    syncedBlockBlockObjectResponse:
      title: Synced Block
      type: object
      properties:
        type:
          type: string
          const: synced_block
        synced_block:
          type: object
          properties:
            synced_from:
              title: Block Id
              type:
                - object
                - 'null'
              properties:
                type:
                  type: string
                  const: block_id
                block_id:
                  $ref: '#/components/schemas/idRequest'
              required:
                - type
                - block_id
          required:
            - synced_from
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - synced_block
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    childPageBlockObjectResponse:
      title: Child Page
      type: object
      properties:
        type:
          type: string
          const: child_page
        child_page:
          $ref: '#/components/schemas/titleObjectResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - child_page
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    childDatabaseBlockObjectResponse:
      title: Child Database
      type: object
      properties:
        type:
          type: string
          const: child_database
        child_database:
          $ref: '#/components/schemas/titleObjectResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - child_database
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    equationBlockObjectResponse:
      title: Equation
      type: object
      properties:
        type:
          type: string
          const: equation
        equation:
          $ref: '#/components/schemas/expressionObjectResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - equation
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    codeBlockObjectResponse:
      title: Code
      type: object
      properties:
        type:
          type: string
          const: code
        code:
          type: object
          properties:
            rich_text:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemResponse'
              maxItems: 100
            caption:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemResponse'
              maxItems: 100
            language:
              $ref: '#/components/schemas/languageRequest'
          required:
            - rich_text
            - caption
            - language
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - code
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    calloutBlockObjectResponse:
      title: Callout
      type: object
      properties:
        type:
          type: string
          const: callout
        callout:
          type: object
          properties:
            rich_text:
              type: array
              items:
                $ref: '#/components/schemas/richTextItemResponse'
              maxItems: 100
            color:
              $ref: '#/components/schemas/apiColor'
            icon:
              anyOf:
                - $ref: '#/components/schemas/pageIconResponse'
                - type: 'null'
          required:
            - rich_text
            - color
            - icon
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - callout
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    dividerBlockObjectResponse:
      title: Divider
      type: object
      properties:
        type:
          type: string
          const: divider
        divider:
          $ref: '#/components/schemas/emptyObject'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - divider
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    breadcrumbBlockObjectResponse:
      title: Breadcrumb
      type: object
      properties:
        type:
          type: string
          const: breadcrumb
        breadcrumb:
          $ref: '#/components/schemas/emptyObject'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - breadcrumb
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    tableOfContentsBlockObjectResponse:
      title: Table Of Contents
      type: object
      properties:
        type:
          type: string
          const: table_of_contents
        table_of_contents:
          type: object
          properties:
            color:
              $ref: '#/components/schemas/apiColor'
          required:
            - color
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - table_of_contents
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    columnListBlockObjectResponse:
      title: Column List
      type: object
      properties:
        type:
          type: string
          const: column_list
        column_list:
          $ref: '#/components/schemas/emptyObject'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - column_list
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    columnBlockObjectResponse:
      title: Column
      type: object
      properties:
        type:
          type: string
          const: column
        column:
          $ref: '#/components/schemas/columnResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - column
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    linkToPageBlockObjectResponse:
      title: Link To Page
      type: object
      properties:
        type:
          type: string
          const: link_to_page
        link_to_page:
          anyOf:
            - title: Page Id
              type: object
              properties:
                type:
                  type: string
                  const: page_id
                page_id:
                  $ref: '#/components/schemas/idRequest'
              required:
                - type
                - page_id
            - title: Database Id
              type: object
              properties:
                type:
                  type: string
                  const: database_id
                database_id:
                  $ref: '#/components/schemas/idRequest'
              required:
                - type
                - database_id
            - title: Comment Id
              type: object
              properties:
                type:
                  type: string
                  const: comment_id
                comment_id:
                  $ref: '#/components/schemas/idRequest'
              required:
                - type
                - comment_id
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - link_to_page
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    tableBlockObjectResponse:
      title: Table
      type: object
      properties:
        type:
          type: string
          const: table
        table:
          $ref: '#/components/schemas/contentWithTableResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - table
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    tableRowBlockObjectResponse:
      title: Table Row
      type: object
      properties:
        type:
          type: string
          const: table_row
        table_row:
          $ref: '#/components/schemas/contentWithTableRowResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - table_row
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    meetingNotesBlockObjectResponse:
      title: Meeting Notes
      type: object
      properties:
        type:
          type: string
          const: meeting_notes
        meeting_notes:
          $ref: '#/components/schemas/transcriptionBlockResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - meeting_notes
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    embedBlockObjectResponse:
      title: Embed
      type: object
      properties:
        type:
          type: string
          const: embed
        embed:
          $ref: '#/components/schemas/mediaContentWithUrlAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - embed
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    bookmarkBlockObjectResponse:
      title: Bookmark
      type: object
      properties:
        type:
          type: string
          const: bookmark
        bookmark:
          $ref: '#/components/schemas/mediaContentWithUrlAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - bookmark
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    imageBlockObjectResponse:
      title: Image
      type: object
      properties:
        type:
          type: string
          const: image
        image:
          $ref: '#/components/schemas/mediaContentWithFileAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - image
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    videoBlockObjectResponse:
      title: Video
      type: object
      properties:
        type:
          type: string
          const: video
        video:
          $ref: '#/components/schemas/mediaContentWithFileAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - video
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    pdfBlockObjectResponse:
      title: Pdf
      type: object
      properties:
        type:
          type: string
          const: pdf
        pdf:
          $ref: '#/components/schemas/mediaContentWithFileAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - pdf
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    fileBlockObjectResponse:
      title: File
      type: object
      properties:
        type:
          type: string
          const: file
        file:
          $ref: '#/components/schemas/mediaContentWithFileNameAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - file
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    audioBlockObjectResponse:
      title: Audio
      type: object
      properties:
        type:
          type: string
          const: audio
        audio:
          $ref: '#/components/schemas/mediaContentWithFileAndCaptionResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - audio
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    linkPreviewBlockObjectResponse:
      title: Link Preview
      type: object
      properties:
        type:
          type: string
          const: link_preview
        link_preview:
          $ref: '#/components/schemas/mediaContentWithUrlResponse'
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - link_preview
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
    unsupportedBlockObjectResponse:
      title: Unsupported
      type: object
      properties:
        type:
          type: string
          const: unsupported
        unsupported:
          type: object
          properties:
            block_type:
              description: >-
                The underlying block type that is not currently supported by the
                Public API. Example values include: tab, form, button, drive.
              type: string
          required:
            - block_type
        parent:
          $ref: '#/components/schemas/parentForBlockBasedObjectResponse'
        object:
          type: string
          const: block
        id:
          type: string
          format: uuid
        created_time:
          type: string
          format: date-time
        created_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        last_edited_time:
          type: string
          format: date-time
        last_edited_by:
          $ref: '#/components/schemas/partialUserObjectResponse'
        has_children:
          type: boolean
        in_trash:
          type: boolean
      required:
        - type
        - unsupported
        - parent
        - object
        - id
        - created_time
        - created_by
        - last_edited_time
        - last_edited_by
        - has_children
        - in_trash
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
    externalFileRequest:
      type: object
      properties:
        url:
          $ref: '#/components/schemas/textRequest'
      additionalProperties: false
      required:
        - url
    fileUploadIdRequest:
      type: object
      properties:
        id:
          $ref: '#/components/schemas/idRequest'
      additionalProperties: false
      required:
        - id
    stringRequest:
      type: string
      maxLength: 100
      minLength: 1
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
    tableRowRequest:
      title: Table Row
      type: object
      properties:
        table_row:
          $ref: '#/components/schemas/contentWithTableRowRequest'
        type:
          type: string
          const: table_row
        object:
          type: string
          const: block
      additionalProperties: false
      required:
        - table_row
    columnBlockWithChildrenRequest:
      title: Column
      type: object
      properties:
        column:
          $ref: '#/components/schemas/columnWithChildrenRequest'
        type:
          type: string
          const: column
        object:
          type: string
          const: block
      additionalProperties: false
      required:
        - column
    headerContentWithSingleLevelOfChildrenRequest:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemRequest'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
        is_toggleable:
          type: boolean
        children:
          type: array
          items:
            $ref: '#/components/schemas/blockObjectRequestWithoutChildren'
          maxItems: 100
      additionalProperties: false
      required:
        - rich_text
    contentWithSingleLevelOfChildrenRequest:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemRequest'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
        children:
          type: array
          items:
            $ref: '#/components/schemas/blockObjectRequestWithoutChildren'
          maxItems: 100
      additionalProperties: false
      required:
        - rich_text
    blockObjectRequestWithoutChildren:
      anyOf:
        - title: Embed
          type: object
          properties:
            embed:
              $ref: '#/components/schemas/mediaContentWithUrlAndCaptionRequest'
            type:
              type: string
              const: embed
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - embed
        - title: Bookmark
          type: object
          properties:
            bookmark:
              $ref: '#/components/schemas/mediaContentWithUrlAndCaptionRequest'
            type:
              type: string
              const: bookmark
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - bookmark
        - title: Image
          type: object
          properties:
            image:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: image
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - image
        - title: Video
          type: object
          properties:
            video:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: video
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - video
        - title: Pdf
          type: object
          properties:
            pdf:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: pdf
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - pdf
        - title: File
          type: object
          properties:
            file:
              $ref: '#/components/schemas/mediaContentWithFileNameAndCaptionRequest'
            type:
              type: string
              const: file
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - file
        - title: Audio
          type: object
          properties:
            audio:
              $ref: '#/components/schemas/mediaContentWithFileAndCaptionRequest'
            type:
              type: string
              const: audio
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - audio
        - title: Code
          type: object
          properties:
            code:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                language:
                  $ref: '#/components/schemas/languageRequest'
                caption:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
              additionalProperties: false
              required:
                - rich_text
                - language
            type:
              type: string
              const: code
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - code
        - title: Equation
          type: object
          properties:
            equation:
              $ref: '#/components/schemas/contentWithExpressionRequest'
            type:
              type: string
              const: equation
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - equation
        - title: Divider
          type: object
          properties:
            divider:
              $ref: '#/components/schemas/emptyObject'
            type:
              type: string
              const: divider
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - divider
        - title: Breadcrumb
          type: object
          properties:
            breadcrumb:
              $ref: '#/components/schemas/emptyObject'
            type:
              type: string
              const: breadcrumb
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - breadcrumb
        - title: Table Of Contents
          type: object
          properties:
            table_of_contents:
              type: object
              properties:
                color:
                  $ref: '#/components/schemas/apiColor'
              additionalProperties: false
            type:
              type: string
              const: table_of_contents
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table_of_contents
        - title: Link To Page
          type: object
          properties:
            link_to_page:
              anyOf:
                - title: Page Id
                  type: object
                  properties:
                    page_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: page_id
                  additionalProperties: false
                  required:
                    - page_id
                - title: Database Id
                  type: object
                  properties:
                    database_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: database_id
                  additionalProperties: false
                  required:
                    - database_id
                - title: Comment Id
                  type: object
                  properties:
                    comment_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: comment_id
                  additionalProperties: false
                  required:
                    - comment_id
            type:
              type: string
              const: link_to_page
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - link_to_page
        - title: Table Row
          type: object
          properties:
            table_row:
              $ref: '#/components/schemas/contentWithTableRowRequest'
            type:
              type: string
              const: table_row
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - table_row
        - title: Heading 1
          type: object
          properties:
            heading_1:
              $ref: '#/components/schemas/headerContentWithRichTextAndColorRequest'
            type:
              type: string
              const: heading_1
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_1
        - title: Heading 2
          type: object
          properties:
            heading_2:
              $ref: '#/components/schemas/headerContentWithRichTextAndColorRequest'
            type:
              type: string
              const: heading_2
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_2
        - title: Heading 3
          type: object
          properties:
            heading_3:
              $ref: '#/components/schemas/headerContentWithRichTextAndColorRequest'
            type:
              type: string
              const: heading_3
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - heading_3
        - title: Paragraph
          type: object
          properties:
            paragraph:
              $ref: '#/components/schemas/contentWithRichTextAndColorRequest'
            type:
              type: string
              const: paragraph
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - paragraph
        - title: Bulleted List Item
          type: object
          properties:
            bulleted_list_item:
              $ref: '#/components/schemas/contentWithRichTextAndColorRequest'
            type:
              type: string
              const: bulleted_list_item
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - bulleted_list_item
        - title: Numbered List Item
          type: object
          properties:
            numbered_list_item:
              $ref: '#/components/schemas/contentWithRichTextAndColorRequest'
            type:
              type: string
              const: numbered_list_item
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - numbered_list_item
        - title: Quote
          type: object
          properties:
            quote:
              $ref: '#/components/schemas/contentWithRichTextAndColorRequest'
            type:
              type: string
              const: quote
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - quote
        - title: To Do
          type: object
          properties:
            to_do:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                checked:
                  type: boolean
                color:
                  $ref: '#/components/schemas/apiColor'
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: to_do
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - to_do
        - title: Toggle
          type: object
          properties:
            toggle:
              $ref: '#/components/schemas/contentWithRichTextAndColorRequest'
            type:
              type: string
              const: toggle
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - toggle
        - title: Template
          type: object
          properties:
            template:
              $ref: '#/components/schemas/contentWithRichTextRequest'
            type:
              type: string
              const: template
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - template
        - title: Callout
          type: object
          properties:
            callout:
              type: object
              properties:
                rich_text:
                  type: array
                  items:
                    $ref: '#/components/schemas/richTextItemRequest'
                  maxItems: 100
                icon:
                  $ref: '#/components/schemas/pageIconRequest'
                color:
                  $ref: '#/components/schemas/apiColor'
              additionalProperties: false
              required:
                - rich_text
            type:
              type: string
              const: callout
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - callout
        - title: Synced Block
          type: object
          properties:
            synced_block:
              type: object
              properties:
                synced_from:
                  title: Block Id
                  type:
                    - object
                    - 'null'
                  properties:
                    block_id:
                      $ref: '#/components/schemas/idRequest'
                    type:
                      type: string
                      const: block_id
                  additionalProperties: false
                  required:
                    - block_id
              additionalProperties: false
              required:
                - synced_from
            type:
              type: string
              const: synced_block
            object:
              type: string
              const: block
          additionalProperties: false
          required:
            - synced_block
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
    contentWithRichTextAndColorResponse:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
      required:
        - rich_text
        - color
    parentForBlockBasedObjectResponse:
      oneOf:
        - $ref: '#/components/schemas/databaseParentResponse'
        - $ref: '#/components/schemas/dataSourceParentResponse'
        - $ref: '#/components/schemas/pageIdParentForBlockBasedObjectResponse'
        - $ref: '#/components/schemas/blockIdParentForBlockBasedObjectResponse'
        - $ref: '#/components/schemas/workspaceParentForBlockBasedObjectResponse'
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
    headerContentWithRichTextAndColorResponse:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
        is_toggleable:
          type: boolean
      required:
        - rich_text
        - color
        - is_toggleable
    contentWithRichTextAndColorAndListResponse:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
        list_start_index:
          type: integer
          minimum: 1
        list_format:
          $ref: '#/components/schemas/numberedListFormat'
      required:
        - rich_text
        - color
    richTextItemResponse:
      allOf:
        - $ref: '#/components/schemas/richTextItemResponseCommon'
        - oneOf:
            - $ref: '#/components/schemas/textRichTextItemResponse'
            - $ref: '#/components/schemas/mentionRichTextItemResponse'
            - $ref: '#/components/schemas/equationRichTextItemResponse'
    titleObjectResponse:
      type: object
      properties:
        title:
          type: string
      required:
        - title
    expressionObjectResponse:
      type: object
      properties:
        expression:
          type: string
      required:
        - expression
    pageIconResponse:
      oneOf:
        - $ref: '#/components/schemas/emojiPageIconResponse'
        - $ref: '#/components/schemas/filePageIconResponse'
        - $ref: '#/components/schemas/externalPageIconResponse'
        - $ref: '#/components/schemas/customEmojiPageIconResponse'
    columnResponse:
      type: object
      properties:
        width_ratio:
          description: >-
            Ratio between 0 and 1 of the width of this column relative to all
            columns in the list. If not provided, uses an equal width.
          examples:
            - 0.5
          type: number
    contentWithTableResponse:
      type: object
      properties:
        has_column_header:
          type: boolean
        has_row_header:
          type: boolean
        table_width:
          type: integer
          minimum: 1
      required:
        - has_column_header
        - has_row_header
        - table_width
    contentWithTableRowResponse:
      type: object
      properties:
        cells:
          type: array
          items:
            type: array
            items:
              $ref: '#/components/schemas/richTextItemResponse'
            maxItems: 100
          maxItems: 100
      required:
        - cells
    transcriptionBlockResponse:
      type: object
      properties:
        title:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
        status:
          $ref: '#/components/schemas/apiTranscriptionStatus'
        children:
          $ref: '#/components/schemas/transcriptionChildrenResponse'
        calendar_event:
          $ref: '#/components/schemas/transcriptionCalendarEventResponse'
        recording:
          $ref: '#/components/schemas/transcriptionRecordingResponse'
    mediaContentWithUrlAndCaptionResponse:
      type: object
      properties:
        url:
          type: string
        caption:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
      required:
        - url
        - caption
    mediaContentWithFileAndCaptionResponse:
      anyOf:
        - $ref: '#/components/schemas/externalMediaContentWithFileAndCaptionResponse'
        - $ref: '#/components/schemas/fileMediaContentWithFileAndCaptionResponse'
    mediaContentWithFileNameAndCaptionResponse:
      anyOf:
        - $ref: >-
            #/components/schemas/externalMediaContentWithFileNameAndCaptionResponse
        - $ref: '#/components/schemas/fileMediaContentWithFileNameAndCaptionResponse'
    mediaContentWithUrlResponse:
      type: object
      properties:
        url:
          $ref: '#/components/schemas/textRequest'
      required:
        - url
    textRequest:
      type: string
      maxLength: 2000
      minLength: 1
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
    headerContentWithRichTextAndColorRequest:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemRequest'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
        is_toggleable:
          type: boolean
      additionalProperties: false
      required:
        - rich_text
    contentWithRichTextAndColorRequest:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemRequest'
          maxItems: 100
        color:
          $ref: '#/components/schemas/apiColor'
      additionalProperties: false
      required:
        - rich_text
    contentWithRichTextRequest:
      type: object
      properties:
        rich_text:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemRequest'
          maxItems: 100
      additionalProperties: false
      required:
        - rich_text
    emojiRequest:
      type: string
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
    dataSourceParentResponse:
      type: object
      properties:
        type:
          type: string
          const: data_source_id
          description: The parent type.
        data_source_id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the parent data source.
        database_id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the data source's parent database.
      additionalProperties: false
      required:
        - type
        - data_source_id
        - database_id
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
    idResponse:
      type: string
      format: uuid
    numberedListFormat:
      type: string
      enum:
        - numbers
        - letters
        - roman
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
    apiTranscriptionStatus:
      type: string
      enum:
        - transcription_not_started
        - transcription_paused
        - transcription_in_progress
        - summary_in_progress
        - notes_ready
    transcriptionChildrenResponse:
      type: object
      properties:
        summary_block_id:
          $ref: '#/components/schemas/idRequest'
        notes_block_id:
          $ref: '#/components/schemas/idRequest'
        transcript_block_id:
          $ref: '#/components/schemas/idRequest'
    transcriptionCalendarEventResponse:
      type: object
      properties:
        start_time:
          type: string
          format: date-time
        end_time:
          type: string
          format: date-time
        attendees:
          type: array
          items:
            $ref: '#/components/schemas/idRequest'
          maxItems: 100
      required:
        - start_time
        - end_time
    transcriptionRecordingResponse:
      type: object
      properties:
        start_time:
          type: string
          format: date-time
        end_time:
          type: string
          format: date-time
    externalMediaContentWithFileAndCaptionResponse:
      title: External
      type: object
      properties:
        type:
          type: string
          const: external
        external:
          type: object
          properties:
            url:
              $ref: '#/components/schemas/textRequest'
          required:
            - url
        caption:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
      required:
        - type
        - external
        - caption
    fileMediaContentWithFileAndCaptionResponse:
      title: File
      type: object
      properties:
        type:
          type: string
          const: file
        file:
          $ref: '#/components/schemas/internalFileResponse'
        caption:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
      required:
        - type
        - file
        - caption
    externalMediaContentWithFileNameAndCaptionResponse:
      title: External
      type: object
      properties:
        type:
          type: string
          const: external
        external:
          type: object
          properties:
            url:
              $ref: '#/components/schemas/textRequest'
          required:
            - url
        caption:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
        name:
          type: string
      required:
        - type
        - external
        - caption
        - name
    fileMediaContentWithFileNameAndCaptionResponse:
      title: File
      type: object
      properties:
        type:
          type: string
          const: file
        file:
          $ref: '#/components/schemas/internalFileResponse'
        caption:
          type: array
          items:
            $ref: '#/components/schemas/richTextItemResponse'
          maxItems: 100
        name:
          type: string
      required:
        - type
        - file
        - caption
        - name
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