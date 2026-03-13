# Capabilities, Permissions, and Sharing

Most Notion access problems are not client-construction problems. They are one of two things:

- the integration does not have the required capability enabled in Notion
- the integration is not shared to the target page, data source, or database

Use this guide as the first checkpoint before debugging request payloads.

## Two separate gates

### 1. Integration capabilities

Capabilities are enabled on the integration itself in Notion's dashboard.
Generated endpoint docs in this SDK already call out the required capability for
many endpoints.

Common groups in this package:

- read content: page reads, markdown reads, block reads, data source reads, and many list operations
- insert content: page creation, block append, database creation, and data source creation
- update content: page updates, page move, markdown updates, block updates, and block deletion
- read comments / insert comments: comment retrieval and comment creation
- user information: `NotionSDK.Users.list/2` and `NotionSDK.Users.retrieve/2`

`NotionSDK.Users.get_self/1` is the least restrictive identity call and is a
good first token check.

### 2. Resource sharing

Capabilities alone are not enough. The integration must also be shared to the
workspace content it is trying to read or mutate.

Practical rules:

- pages must be shared with the integration before page or block calls can succeed
- if the page lives under a data source or database, share the parent container too
- file-upload follow-up workflows still need the destination page or parent shared
- template-based page creation requires the integration to have access to the template page as well

## Quick endpoint map

These are the capability patterns that matter most in day-to-day use:

- `NotionSDK.Pages.retrieve/2`, `NotionSDK.Pages.retrieve_property/2`, `NotionSDK.Pages.retrieve_markdown/2`, `NotionSDK.Blocks.retrieve/2`, `NotionSDK.Blocks.list_children/2`, `NotionSDK.DataSources.retrieve/2`, and `NotionSDK.DataSources.query/2` need content-read access
- `NotionSDK.Pages.create/2`, `NotionSDK.Blocks.append_children/2`, `NotionSDK.Databases.create/2`, and `NotionSDK.DataSources.create/2` need content-insert access
- `NotionSDK.Pages.update/2`, `NotionSDK.Pages.move/2`, `NotionSDK.Pages.update_markdown/2`, `NotionSDK.Blocks.update/2`, `NotionSDK.Blocks.delete/2`, `NotionSDK.Databases.update/2`, and `NotionSDK.DataSources.update/2` need content-update access
- `NotionSDK.Comments.list/2` and `NotionSDK.Comments.retrieve/2` need comment-read access
- `NotionSDK.Comments.create/2` needs comment-insert access
- `NotionSDK.Users.list/2` and `NotionSDK.Users.retrieve/2` need user-information access

Comments are a common trap because comment capabilities are off by default for
many integrations.

## Before blaming the SDK

Check these in order:

1. The token is valid by calling `NotionSDK.Users.get_self/1`.
2. The integration has the right capability enabled in the Notion dashboard.
3. The target page, data source, or database is shared with that integration.
4. The parent container is shared when the operation depends on parent metadata.
5. The request is using the expected auth scheme for that endpoint.

## Related guides

- `getting-started.md` for the base client flow
- `oauth-and-auth-overrides.md` for bearer vs Basic auth behavior
- `content-creation-and-mutation.md` for write-heavy workflows
- `examples/README.md` for live fixture setup
