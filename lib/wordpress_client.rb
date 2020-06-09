require "wordpress_client/version"
require "wordpress_client/errors"

require "wordpress_client/rest_parser"
require "wordpress_client/connection"
require "wordpress_client/client"
require "wordpress_client/paginated_collection"

require "wordpress_client/term"
require "wordpress_client/category"
require "wordpress_client/tag"

require "wordpress_client/post"
require "wordpress_client/post_parser"
require "wordpress_client/media"
require "wordpress_client/media_parser"
require "wordpress_client/comment"
require "wordpress_client/comment_parser"

module WordpressClient
  # Initialize a new client using the provided connection details.
  # You need to provide authentication details, and the user must have +edit+
  # permissions on the blog if you want to read Post Meta, or to modify
  # anything.
  #
  # @example
  #   client = WordpressClient.new(
  #     url: "https://blog.example.com/wp-json",
  #     username: "bot",
  #     password: ENV.fetch("WORDPRESS_PASSWORD"),
  #   )
  #
  # @see Client Client, for the methods available after creating the connection.
  #
  # @param url [String] The base URL to the wordpress install, including
  #                     +/wp-json+.
  # @param username [String] A valid username on the wordpress installation.
  # @param password [String] The password for the provided user.
  # @return {Client}
  def self.new(url:, username:, password:)
    Client.new(Connection.new(url: url, username: username, password: password))
  end
end
