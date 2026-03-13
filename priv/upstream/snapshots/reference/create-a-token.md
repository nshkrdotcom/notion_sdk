> ## Documentation Index
> Fetch the complete documentation index at: https://developers.notion.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Create a token

> Creates an access token that a third-party service can use to authenticate with Notion.

export const integrationsDashboardUrl = "https://www.notion.so/profile/integrations";

<Info>
  For step-by-step instructions on how to use this endpoint to create a public integration, check out the [Authorization guide](/guides/get-started/authorization#set-up-the-auth-flow-for-a-public-integration). To walkthrough how to create tokens for Link Previews, refer to the [Link Previews guide](/guides/link-previews/build-a-link-preview-integration).
</Info>

<Warning>
  **Redirect URI requirements for public integrations**

  The `redirect_uri` is a *required* field in the request body for this endpoint if:

  * the `redirect_uri` query parameter was set in the [Authorization URL](/guides/get-started/authorization#step-1-navigate-the-user-to-the-integrations-authorization-url) provided to users, *or*;
  * there are more than one `redirect_uri`s included in the <a href={integrationsDashboardUrl}>integration's settings</a> under **OAuth Domain & URIs**.

  In most cases, the `redirect_uri` field is required.

  This field is not allowed in the request body if:

  * there is one `redirect_uri` included in the <a href={integrationsDashboardUrl}>integration's settings</a> under **OAuth Domain & URIs**, *and* the `redirect_uri` query parameter was not included in the Authorization URL.

  Learn more in the public integration section of the [Authorization Guide](/guides/get-started/authorization#public-integration-auth-flow-set-up).

  *Note: Each Public API endpoint can return several possible error codes. To see a full description of each type of error code, see the [Error codes section](/reference/status-codes#error-codes) of the Status codes documentation.*
</Warning>


## OpenAPI

````yaml post /v1/oauth/token
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
  /v1/oauth/token:
    post:
      tags:
        - OAuth
      summary: Exchange an authorization code for an access and refresh token
      operationId: create-a-token
      parameters:
        - $ref: '#/components/parameters/notionVersion'
      requestBody:
        required: true
        content:
          application/json:
            schema:
              anyOf:
                - type: object
                  properties:
                    grant_type:
                      type: string
                      const: authorization_code
                    code:
                      type: string
                    redirect_uri:
                      type: string
                    external_account:
                      type: object
                      properties:
                        key:
                          type: string
                        name:
                          type: string
                      required:
                        - key
                        - name
                  required:
                    - grant_type
                    - code
                - type: object
                  properties:
                    grant_type:
                      type: string
                      const: refresh_token
                    refresh_token:
                      type: string
                  required:
                    - grant_type
                    - refresh_token
      responses:
        '200':
          description: ''
          content:
            application/json:
              schema:
                type: object
                properties:
                  access_token:
                    type: string
                  token_type:
                    type: string
                    const: bearer
                  refresh_token:
                    type:
                      - string
                      - 'null'
                  bot_id:
                    type: string
                    format: uuid
                  workspace_icon:
                    type:
                      - string
                      - 'null'
                  workspace_name:
                    type:
                      - string
                      - 'null'
                  workspace_id:
                    type: string
                    format: uuid
                  owner:
                    anyOf:
                      - title: User
                        type: object
                        properties:
                          type:
                            type: string
                            const: user
                          user:
                            anyOf:
                              - title: Person
                                type: object
                                properties:
                                  type:
                                    type: string
                                    const: person
                                  person:
                                    type: object
                                    properties:
                                      email:
                                        type: string
                                    additionalProperties: false
                                    required:
                                      - email
                                  name:
                                    type:
                                      - string
                                      - 'null'
                                  avatar_url:
                                    type:
                                      - string
                                      - 'null'
                                  id:
                                    $ref: '#/components/schemas/idRequest'
                                  object:
                                    type: string
                                    const: user
                                required:
                                  - type
                                  - person
                                  - name
                                  - avatar_url
                                  - id
                                  - object
                              - $ref: '#/components/schemas/partialUserObjectResponse'
                        required:
                          - type
                          - user
                      - title: Workspace
                        type: object
                        properties:
                          type:
                            type: string
                            const: workspace
                          workspace:
                            type: boolean
                            const: true
                        required:
                          - type
                          - workspace
                  duplicated_template_id:
                    type:
                      - string
                      - 'null'
                    format: uuid
                  request_id:
                    type: string
                    format: uuid
                required:
                  - access_token
                  - token_type
                  - refresh_token
                  - bot_id
                  - workspace_icon
                  - workspace_name
                  - workspace_id
                  - owner
                  - duplicated_template_id
        '400':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_oauth_400'
        '401':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_oauth_401'
        '403':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_oauth_403'
        '500':
          description: ''
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/error_oauth_500'
      security:
        - basicAuth: []
      x-codeSamples:
        - lang: javascript
          label: TypeScript SDK
          source: |-
            import { Client } from "@notionhq/client"

            const notion = new Client()

            const response = await notion.oauth.token({
              client_id: process.env.OAUTH_CLIENT_ID,
              client_secret: process.env.OAUTH_CLIENT_SECRET,
              grant_type: "authorization_code",
              code: "abc123-authorization-code",
              redirect_uri: "https://example.com/callback"
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
    error_oauth_400:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - invalid_request
                - invalid_grant
                - unauthorized_client
                - unsupported_grant_type
                - invalid_scope
            status:
              const: 400
          required:
            - code
            - status
          additionalProperties: false
    error_oauth_401:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - invalid_client
            status:
              const: 401
          required:
            - code
            - status
          additionalProperties: false
    error_oauth_403:
      allOf:
        - $ref: '#/components/schemas/publicApiCommonErrorResponse'
        - type: object
          properties:
            code:
              enum:
                - test_env_error
            status:
              const: 403
          required:
            - code
            - status
          additionalProperties: false
    error_oauth_500:
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
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
    basicAuth:
      type: http
      scheme: basic

````