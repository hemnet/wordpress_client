require "time"

module WordpressClient
  # Represents a comment in Wordpress.
  #
  # @see http://v2.wp-api.org/reference/comments/ API documentation for Comment
  class Comment
    attr_accessor(
      :id, :url, :content_html, :date, 
      :post, :parent, :meta,
      :author, :author_email, :author_name,
      :author_avatar_urls, :author_url
    )

    # @!attribute [rw] author
    #   @return [Fixnum] the id of the author of the comment, if available

    # @!attribute [rw] author_email
    #   @return [String] the email of the author of the comment

    # @!attribute [rw] author_name
    #   @return [String] the name of the author of the comment

    # @!attribute [rw] author_url
    #   @return [String] the url of the author of the comment

    # @!attribute [rw] author_avatar_urls
    #   Returns the avatar urls of the Comment author, as a +Hash+ of +String => String+.
    #
    #   @example
    #     comment.author_avatar_urls # => { "24" => "http://2.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=24&d=mm&r=g", "48" => "http://2.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=48&d=mm&r=g" }
    #
    #   @return [Hash<String,String>] the avatar urls of the Comment author, as a Hash.

    # @!attribute [rw] content_html
    #   @return [String] the content of the media, HTML escaped
    #   @example
    #     comment.content_html #=> "Fire &#038; diamonds!"

    # @!attribute [rw] date
    #   @return [Time, nil] the date of the comment, in UTC if available

    # @!attribute [rw] url
    #   @return [String] the URL (link) to the comment

    # @!attribute [rw] post
    #   @return [Fixnum] the id of the post this comment belongs to

    # @!attribute [rw] parent
    #   @return [Fixnum] the id of the parent comment to this comment

    # @!attribute [rw] meta
    #   Returns the Comment meta, as a +Hash+ of +String => String+.
    #
    #   @example
    #     comment.meta # => {"Mood" => "Happy", "reviewed_by" => "user:45"}
    #
    #   @return [Hash<String,String>] the comment meta, as a Hash.

    # @api private
    def self.parse(data)
      CommentParser.parse(data)
    end

    def initialize(
      id: nil,
      author: nil,
      author_email: nil,
      author_name: nil,
      author_avatar_urls: {},
      author_url: nil,
      url: nil,
      content_html: nil,
      date: nil,
      post: nil,
      parent: nil,
      meta: {}
    )
      @id = id
      @author = author,
      @author_email = author_email,
      @author_name = author_name,
      @author_avatar_urls = author_avatar_urls,
      @author_url = author_url,
      @url = url,
      @content_html = content_html,
      @date = date,
      @post = post,
      @parent = parent,
      @meta = meta
    end
  end
end
