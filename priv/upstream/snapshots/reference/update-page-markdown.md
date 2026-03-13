> ## Documentation Index
> Fetch the complete documentation index at: https://developers.notion.com/llms.txt
> Use this file to discover all available pages before exploring further.

> Insert or replace content in a page using enhanced markdown.

# Update a page's content as markdown

export const integrationsDashboardUrl = "https://www.notion.so/profile/integrations";

### Use cases

#### Inserting content

Use the `insert_content` command to add new markdown content to a page. Provide an `after` selection to insert at a specific point, or omit it to append to the end of the page.

The `after` parameter uses an **ellipsis-based selection** format: `"start text...end text"`. This matches a range from the first occurrence of the start text to the end text.

#### Replacing content

Use the `replace_content_range` command to replace a matched range of existing content with new markdown. The `content_range` parameter uses the same ellipsis-based selection format as `after`.

### General behavior

Returns a `page_markdown` object containing the full page content as enhanced markdown after the update, including `truncated` and `unknown_block_ids` fields for large pages.

<Info>
  **Requirements**

  Your integration must have [update content capabilities](/reference/capabilities#content-capabilities) on the target page in order to call this endpoint. To update your integration's capabilities, navigate to the <a href={integrationsDashboardUrl}>My integrations</a> dashboard, select your integration, go to the **Capabilities** tab, and update your settings as needed.

  Attempting to call this endpoint without update content capabilities returns an HTTP response with a 403 status code.
</Info>

<Tip>
  **Newlines in content**

  The `content` field expects standard markdown with actual newline characters. In JSON, `\n` is the escape sequence for a newline — for example, `"## Heading\n\nParagraph"` creates a heading followed by a paragraph.

  When using cURL, wrap the `--data` body in **single quotes** (`'...'`) so that `\n` is passed through to the JSON parser. Avoid `$'...'` quoting, which converts `\n` into a literal newline and produces invalid JSON.

  Note that the interactive API explorer on this page does not support multiline input. To test with newlines, use cURL, an SDK, or any HTTP client that sends properly encoded JSON.
</Tip>

<Warning>
  **Protecting child pages and databases**

  By default, this endpoint refuses to delete child pages or databases. If an operation would remove them, a `validation_error` is returned listing the affected items. Set `allow_deleting_content` to `true` in the `replace_content_range` body to permit deletion.
</Warning>

### Errors

| Error code         | Condition                                                                                       |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| `validation_error` | The `content_range` or `after` selection does not match any content in the page.                |
| `validation_error` | The operation would delete child pages or databases and `allow_deleting_content` is not `true`. |
| `validation_error` | The provided ID is a database or non-page block.                                                |
| `validation_error` | The target page is a synced page. Synced pages cannot be updated.                               |
| `object_not_found` | The page does not exist or the integration does not have access to it.                          |

*Each Public API endpoint can return several possible error codes. See the [Error codes section](/reference/status-codes#error-codes) of the Status codes documentation for more information.*


## OpenAPI

````yaml patch /v1/pages/{page_id}/markdown
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
  /v1/pages/{page_id}/markdown:
    patch:
      tags:
        - Pages
      summary: Update a page's content as markdown
      operationId: update-page-markdown
      parameters:
        - name: page_id
          in: path
          required: true
          schema:
            $ref: '#/components/schemas/idRequest'
            description: The ID of the page to update.
        - $ref: '#/components/parameters/notionVersion'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              oneOf:
                - type: object
                  properties:
                    type:
                      type: string
                      const: insert_content
                      description: Always `insert_content`
                    insert_content:
                      type: object
                      properties:
                        content:
                          type: string
                          examples:
                            - |-
                              ## New Section

                              Inserted content here.
                          description: >-
                            The enhanced markdown content to insert into the
                            page.
                        after:
                          type: string
                          description: >-
                            Selection of existing content to insert after, using
                            the ellipsis format ("start text...end text"). Omit
                            to append at the end of the page.
                      required:
                        - content
                      description: Insert new content into the page.
                  required:
                    - type
                    - insert_content
                  title: Insert Content
                - type: object
                  properties:
                    type:
                      type: string
                      const: replace_content_range
                      description: Always `replace_content_range`
                    replace_content_range:
                      type: object
                      properties:
                        content:
                          type: string
                          examples:
                            - |-
                              ## Updated Section

                              New content replaces the old.
                          description: >-
                            The new enhanced markdown content to replace the
                            matched range.
                        content_range:
                          type: string
                          description: >-
                            Selection of existing content to replace, using the
                            ellipsis format ("start text...end text").
                        allow_deleting_content:
                          type: boolean
                          description: >-
                            Set to true to allow the operation to delete child
                            pages or databases. Defaults to false.
                      required:
                        - content
                        - content_range
                      description: Replace a range of content in the page.
                  required:
                    - type
                    - replace_content_range
                  title: Replace Content Range
      responses:
        '200':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/pageMarkdownResponse'
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

            const response = await notion.pages.updateMarkdown({
              page_id: "b55c9c91-384d-452b-81db-d1ef79372b75",
              type: "insert_content",
              insert_content: {
                content: "## New Section\n\nInserted content here.",
                after: "# Heading...end of section"
              }
            })
components:
  schemas:
    idRequest:
      type: string
    pageMarkdownResponse:
      type: object
      properties:
        object:
          type: string
          const: page_markdown
          description: The type of object, always 'page_markdown'.
        id:
          $ref: '#/components/schemas/idResponse'
          description: The ID of the page or block.
        markdown:
          type: string
          description: The page content rendered as enhanced Markdown.
        truncated:
          type: boolean
          description: >-
            Whether the content was truncated due to exceeding the record count
            limit.
        unknown_block_ids:
          type: array
          items:
            $ref: '#/components/schemas/idResponse'
          maxItems: 100
          description: >-
            Block IDs that could not be loaded (appeared as <unknown> tags in
            the markdown). Pass these IDs back to this endpoint to fetch their
            content separately.
      additionalProperties: false
      required:
        - object
        - id
        - markdown
        - truncated
        - unknown_block_ids
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
    idResponse:
      type: string
      format: uuid
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