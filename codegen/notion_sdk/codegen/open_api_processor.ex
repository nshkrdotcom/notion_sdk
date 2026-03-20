defmodule NotionSDK.Codegen.OpenAPIProcessor do
  @moduledoc false

  use OpenAPI.Processor

  alias OpenAPI.Processor.Naming
  alias OpenAPI.Spec.Path.Operation, as: OperationSpec

  @operation_names %{
    {"get", "/v1/users/me"} => :get_self,
    {"get", "/v1/users/{user_id}"} => :retrieve,
    {"get", "/v1/users"} => :list,
    {"post", "/v1/pages"} => :create,
    {"get", "/v1/pages/{page_id}"} => :retrieve,
    {"patch", "/v1/pages/{page_id}"} => :update,
    {"post", "/v1/pages/{page_id}/move"} => :move,
    {"get", "/v1/pages/{page_id}/properties/{property_id}"} => :retrieve_property,
    {"get", "/v1/pages/{page_id}/markdown"} => :retrieve_markdown,
    {"patch", "/v1/pages/{page_id}/markdown"} => :update_markdown,
    {"get", "/v1/blocks/{block_id}"} => :retrieve,
    {"patch", "/v1/blocks/{block_id}"} => :update,
    {"delete", "/v1/blocks/{block_id}"} => :delete,
    {"get", "/v1/blocks/{block_id}/children"} => :list_children,
    {"patch", "/v1/blocks/{block_id}/children"} => :append_children,
    {"get", "/v1/data_sources/{data_source_id}"} => :retrieve,
    {"patch", "/v1/data_sources/{data_source_id}"} => :update,
    {"post", "/v1/data_sources/{data_source_id}/query"} => :query,
    {"post", "/v1/data_sources"} => :create,
    {"get", "/v1/data_sources/{data_source_id}/templates"} => :list_templates,
    {"get", "/v1/databases/{database_id}"} => :retrieve,
    {"patch", "/v1/databases/{database_id}"} => :update,
    {"post", "/v1/databases"} => :create,
    {"post", "/v1/search"} => :search,
    {"post", "/v1/comments"} => :create,
    {"get", "/v1/comments"} => :list,
    {"get", "/v1/comments/{comment_id}"} => :retrieve,
    {"post", "/v1/file_uploads"} => :create,
    {"get", "/v1/file_uploads"} => :list,
    {"post", "/v1/file_uploads/{file_upload_id}/send"} => :send,
    {"post", "/v1/file_uploads/{file_upload_id}/complete"} => :complete,
    {"get", "/v1/file_uploads/{file_upload_id}"} => :retrieve,
    {"post", "/v1/oauth/token"} => :token,
    {"post", "/v1/oauth/revoke"} => :revoke,
    {"post", "/v1/oauth/introspect"} => :introspect
  }

  @impl OpenAPI.Processor
  def operation_function_name(
        state,
        %OperationSpec{
          "$oag_path": path,
          "$oag_path_method": method
        } = operation_spec
      ) do
    Map.get(@operation_names, {method, path}) || Naming.operation_function(state, operation_spec)
  end
end
