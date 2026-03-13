> ## Documentation Index
> Fetch the complete documentation index at: https://developers.notion.com/llms.txt
> Use this file to discover all available pages before exploring further.

> Use this API to manage [widgets](/reference/widget).

# Manage widgets

export const dashboardUrl = "https://www.notion.so/profile/integrations";

<Warning>
  **Widget consistency**

  Widget writes may lag behind reads.

  * Retry after a short delay.
</Warning>

Creates and updates [widget entries](/reference/widget-entry).

<Info>
  For workspace setup, open the <a href={dashboardUrl}>Integrations dashboard</a>.
</Info>

### Behavior

Widgets are grouped by [workspace](/reference/workspace).

### Limits

The endpoint accepts up to 10 widget ids.

* Maximum of 10 ids
* Maximum name length of 50 characters

### Errors

Returns a 409 on conflicts.

## OpenAPI

````yaml post /v1/widgets
openapi: 3.1.0
info:
  title: Widget API
  version: 1.0.0
paths:
  /v1/widgets:
    post:
      summary: Manage widgets
      operationId: manage-widgets
      x-codeSamples:
        - lang: javascript
          label: TypeScript SDK
          source: |-
            const response = await notion.widgets.create()
      responses:
        '200':
          description: ok
````
