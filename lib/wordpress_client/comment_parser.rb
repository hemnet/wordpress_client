module WordpressClient
  # @private
  class CommentParser
    include RestParser

    def self.parse(data)
      new(data).to_comment
    end

    def initialize(data)
      @data = data
    end

    def to_comment
      comment = Comment.new
      assign_basic(comment)
      assign_rendered(comment)
      assign_dates(comment)
      comment
    end

    private
    attr_reader :data

    def assign_basic(comment)
      comment.id = data["id"]
      comment.url = data["link"]
      comment.meta = data["meta"]
      comment.author = data["author"]
      comment.author_email = data["author_email"]
      comment.author_name = data["author_name"]
      comment.author_avatar_urls = data["author_avatar_urls"]
      comment.author_url = data["author_url"]
      comment.post = data["post"]
      comment.parent = data["parent"]
    end

    def assign_dates(comment)
      comment.date = read_date("date")
    end

    def assign_rendered(comment)
      comment.content_html = rendered("content")
    end
  end
end
