require "spec_helper"

module WordpressClient
  describe Comment do
    let(:fixture) { json_fixture("simple-comment.json") }

    it "can be parsed from JSON data" do
      comment = Comment.parse(fixture)

      expect(comment.id).to eq 5517
      expect(comment.url).to eq "http://example.com/2015/11/03/hello-world/#comment-5517"
      expect(comment.post).to eq 1680
      expect(comment.parent).to eq 5516
      expect(comment.content_html).to eq("<p>Hi thanks for commenting!</p>")

      expect(comment.author).to eq 1
      expect(comment.author_name).to eq "author"
      expect(comment.author_url).to eq "www.example.com"
      expect(comment.author_avatar_urls).to eq ({
        "24" => "http://2.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=24&d=mm&r=g",
        "48" => "http://2.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=48&d=mm&r=g",
        "96" => "http://2.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=96&d=mm&r=g"
      })

      expect(comment.date).to_not be nil
    end

    describe "dates" do
      it "uses GMT times if available" do
        comment = Comment.parse(fixture.merge(
          "date_gmt" => "2001-01-01T15:00:00",
          "date" => "2001-01-01T12:00:00",
        ))

        expect(comment.date).to eq Time.utc(2001, 1, 1, 15, 0, 0)
      end

      it "falls back to local time if no GMT date is provided" do
        comment = Comment.parse(fixture.merge(
          "date_gmt" => nil,
          "date" => "2001-01-01T12:00:00",
        ))

        expect(comment.date).to eq Time.local(2001, 1, 1, 12, 0, 0)
      end
    end

  end
end
