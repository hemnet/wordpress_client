module WordpressClient
  class Client
    def initialize(connection)
      @connection = connection
    end

    # @!group Posts

    # Find {Post Posts} matching given parameters.
    #
    # @example Finding 5 posts
    #   posts = client.posts(per_page: 5)
    #
    # @param page [Fixnum] Current page for pagination. Defaults to 1.
    # @param per_page [Fixnum] Posts per page. Defaults to 10.
    #
    # @return {PaginatedCollection[Post]} Paginated collection of the found posts.
    def posts(per_page: 10, page: 1)
      connection.get_multiple(
        Post,
        "posts",
        per_page: per_page,
        page: page,
        _embed: nil,
      )
    end

    # Find the {Post} with the given ID, or raises an error if not found.
    #
    # @return {Post}
    # @raise {NotFoundError}
    # @raise {subclasses of Error} on other unexpected errors
    def find_post(id)
      connection.get(Post, "posts/#{id.to_i}", _embed: nil)
    end

    # Create a new {Post} with the given attributes in Wordpress and return it.
    #
    # In addition to {http://v2.wp-api.org/reference/posts/ the accepted
    # parameters of the API}, this method also takes the following keys:
    # * +:meta+
    # * +:category_ids+
    # * +:tag_ids+
    #
    # @see http://v2.wp-api.org/reference/posts/ List of accepted parameters
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   accepted parameters or the custom parameters listed
    #                   above.
    # @option attributes [Hash<String,String>] meta Hash of meta values.
    # @option attributes [Array<Fixnum>] category_ids List of category IDs the
    #                                    Post should belong to.
    # @option attributes [Array<Fixnum>] tag_ids List of tag IDs the Post
    #                                    should have.
    #
    # @return {Post}
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def create_post(attributes)
      connection.create(Post, "posts", attributes, redirect_params: {_embed: nil})
    end

    # Update the {Post} with the given id, setting the supplied attributes in
    # Wordpress and returning an updated Post.
    #
    # In addition to {http://v2.wp-api.org/reference/posts/ the accepted
    # parameters of the API}, this method also takes the following keys:
    # * +:meta+
    # * +:category_ids+
    # * +:tag_ids+
    #
    # @example Changing the title of a Post
    #   new_post = client.update_post(post.id, title: "A better title")
    #   new_post.title_html #=> "A better title"
    #
    # @see http://v2.wp-api.org/reference/posts/ List of accepted parameters
    # @param id [Fixnum] ID of the post to update.
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   accepted parameters or the custom parameters listed
    #                   above.
    # @option attributes [Hash<String,String>] meta Hash of meta values.
    # @option attributes [Array<Fixnum>] category_ids List of category IDs the
    #                                    Post should belong to.
    # @option attributes [Array<Fixnum>] tag_ids List of tag IDs the Post
    #                                    should have.
    #
    # @return {Post}
    # @raise {NotFoundError}
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def update_post(id, attributes)
      connection.put(Post, "posts/#{id.to_i}", attributes)
    end

    # Deletes the {Post} with the given ID.
    #
    # @param id [Fixnum] The {Post} ID.
    # @param force [Boolean] When +false+, the Post will be put in the "Trash"
    #        of Wordpress. +true+ causes the Post to be irrevocably deleted.
    #
    # @return true always
    def delete_post(id, force: false)
      connection.delete("posts/#{id.to_i}", {"force" => force})
    end

    # Search {Post Posts} matching given parameters.
    #
    # @example Finding 5 posts about debt
    #   posts = client.search('debt', per_page: 5)
    #
    # @param search [String] Keyword for the search
    # @param page [Fixnum] Current page for pagination. Defaults to 1.
    # @param per_page [Fixnum] Posts per page. Defaults to 10.
    #
    # @return {PaginatedCollection[Post]} Paginated collection of the found posts.
    def search(search, params = {})
      params[:_embed] ||= nil
      params[:per_page] ||=  10
      params[:page] ||= 1 
      connection.get_multiple(
        Post,
        "search?search=#{search}",
        params
      )
    end

    # @!group Categories

    # Find {Category Categories} in the Wordpress install.
    #
    # @return {PaginatedCollection[Category]}
    def categories(per_page: 10, page: 1)
      connection.get_multiple(Category, "categories", page: page, per_page: per_page)
    end

    # Find {Category} with the given ID.
    #
    # @return {Category}
    # @raise {NotFoundError}
    # @raise {subclasses of Error} on other unexpected errors
    def find_category(id)
      connection.get(Category, "categories/#{id.to_i}")
    end

    # Create a new {Category} with the given attributes.
    #
    # @see http://v2.wp-api.org/reference/taxonomies/ List of accepted parameters
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   parameters accepted by the API.
    # @option attributes [String] name Name of the category (required).
    # @option attributes [String] slug Slug of the category (optional).
    # @option attributes [String] description Description of the category (optional).
    #
    # @return {Category} the new Category
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def create_category(attributes)
      connection.create(Category, "categories", attributes)
    end

    # Update the {Category} with the given id, setting the supplied attributes.
    #
    # @see http://v2.wp-api.org/reference/taxonomies/ List of accepted parameters
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   parameters accepted by the API.
    # @option attributes [String] name Name of the category.
    # @option attributes [String] slug Slug of the category.
    # @option attributes [String] description Description of the category.
    #
    # @return {Category} the updated Category
    # @raise {NotFoundError}
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def update_category(id, attributes)
      connection.put(Category, "categories/#{id.to_i}", attributes)
    end

    # @!group Tags

    # Find {Tag Tags} in the Wordpress install.
    #
    # @return {PaginatedCollection[Tag]}
    def tags(per_page: 10, page: 1)
      connection.get_multiple(Tag, "tags", page: page, per_page: per_page)
    end

    # Find {Tag} with the given ID.
    #
    # @return {Tag}
    # @raise {NotFoundError}
    # @raise {subclasses of Error} on other unexpected errors
    def find_tag(id)
      connection.get(Tag, "tags/#{id.to_i}")
    end

    # Create a new {Tag} with the given attributes.
    #
    # @see http://v2.wp-api.org/reference/taxonomies/ List of accepted parameters
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   parameters accepted by the API.
    # @option attributes [String] name Name of the tag (required).
    # @option attributes [String] slug Slug of the tag (optional).
    # @option attributes [String] description Description of the tag (optional).
    #
    # @return {Tag} the new Tag
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def create_tag(attributes)
      connection.create(Tag, "tags", attributes)
    end

    # Update the {Tag} with the given id, setting the supplied attributes.
    #
    # @see http://v2.wp-api.org/reference/taxonomies/ List of accepted parameters
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   parameters accepted by the API.
    # @option attributes [String] name Name of the tag.
    # @option attributes [String] slug Slug of the tag.
    # @option attributes [String] description Description of the tag.
    #
    # @return {Tag} the updated Tag
    # @raise {NotFoundError}
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def update_tag(id, attributes)
      connection.put(Tag, "tags/#{id.to_i}", attributes)
    end

    # @!group Media

    # Find {Media} in the Wordpress install.
    #
    # @return {PaginatedCollection[Media]}
    def media(per_page: 10, page: 1)
      connection.get_multiple(Media, "media", page: page, per_page: per_page)
    end

    # Find {Media} with the given ID.
    #
    # @return {Media}
    # @raise {NotFoundError}
    # @raise {subclasses of Error} on other unexpected errors
    def find_media(id)
      connection.get(Media, "media/#{id.to_i}")
    end

    # Create a new {Media} by uploading a IO stream.
    #
    # You need to provide both MIME type and filename for Wordpress to accept
    # the file.
    #
    # @example Uploading a JPEG from a request
    #   media = client.upload(
    #     request.body_stream, filename: "foo.jpg", mime_type: "image/jpeg"
    #   )
    #
    # @param io [IO-like object] IO stream (for example an open file) that will
    #        be the body of the media.
    # @param mime_type [String] the MIME type of the IO stream
    # @param filename [String] the filename that Wordpress should see. Requires
    #        a file extension to make Wordpress happy.
    #
    # @return {Media} the new Media
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    # @see #upload_file #upload_file - a shortcut for uploading files on disk
    def upload(io, mime_type:, filename:)
      connection.upload(Media, "media", io, mime_type: mime_type, filename: filename)
    end

    # Create a new {Media} by uploading a file from disk.
    #
    # You need to provide MIME type for Wordpress to accept the file. The
    # filename that Wordpress sees will automatically be derived from the
    # passed path.
    #
    # @example Uploading a JPEG from disk
    #   media = client.upload_file(
    #     "assets/ocean.jpg", mime_type: "image/jpeg"
    #   )
    #
    # @param filename [String] a path to a readable file.
    # @param mime_type [String] the MIME type of the file.
    #
    # @return {Media} the new Media
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    # @see #upload #upload - for when you want to upload something that isn't a
    #              file on disk, or need extra flexibility
    def upload_file(filename, mime_type:)
      path = filename.to_s
      File.open(path, 'r') do |file|
        upload(file, mime_type: mime_type, filename: File.basename(path))
      end
    end

    # Update the {Media} with the given id, setting the supplied attributes.
    #
    # @see http://v2.wp-api.org/reference/media/ List of accepted parameters
    # @param attributes [Hash<Symbol,Object>] attribute list, containing
    #                   parameters accepted by the API.
    #
    # @return {Media} The updated Media
    # @raise {NotFoundError}
    # @raise {ValidationError}
    # @raise {subclasses of Error} on other unexpected errors
    def update_media(id, attributes)
      connection.put(Media, "media/#{id.to_i}", attributes)
    end

    # @!endgroup

    def inspect
      "#<WordpressClient::Client #{connection.inspect}>"
    end

    private
    attr_reader :connection
  end
end
