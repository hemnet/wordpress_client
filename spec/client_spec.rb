require "spec_helper"
require "tmpdir"

module WordpressClient
  describe Client do
    subject(:client) { Client.new(connection) }
    let(:connection) { instance_double(Connection) }

    describe "finding posts" do
      it "has working pagination" do
        expect(connection).to receive(:get_multiple).with(
          Post, "posts", hash_including(page: 2, per_page: 13)
        ).and_return []

        expect(client.posts(per_page: 13, page: 2)).to eq []
      end

      it "embeds linked resources" do
        expect(connection).to receive(:get_multiple).with(
          Post, "posts", hash_including(_embed: nil)
        ).and_return []

        expect(client.posts).to eq []
      end
    end

    describe "fetching a single post" do
      it "embeds linked resources" do
        post = instance_double(Post)

        expect(connection).to receive(:get).with(
          Post, "posts/5", _embed: nil
        ).and_return post

        expect(client.find_post(5)).to eq post
      end

    end

    describe "creating a post" do
      it "embeds linked resources when following redirect" do
        post = instance_double(Post, id: 5)
        attributes = {title: "Foo"}

        expect(connection).to receive(:create).with(
          Post, "posts", attributes, redirect_params: {_embed: nil}
        ).and_return post

        # We don't expect here as the `create` call below could be enough, but
        # it's also very possible that we need to fetch the post again after
        # doing other things to it.
        allow(connection).to receive(:get).with(
          Post, "posts/5"
        ).and_return(post)

        expect(client.create_post(attributes)).to eq post
      end

    end

    describe "updating a post" do
      it "embeds linked resources" do
        post = instance_double(Post)

        expect(connection).to receive(:put).with(
          Post, "posts/5", hash_including(title: "Foo")
        ).and_return(post)

        expect(client.update_post(5, title: "Foo")).to eq post
      end

    end
    describe "deleting posts" do
      it "deletes a post without force by default" do
        expect(connection).to receive(:delete).with(
          "posts/1", {"force" => false}
        ).and_return true

        expect(client.delete_post(1)).to eq true
      end

      it "deletes a post without force" do
        expect(connection).to receive(:delete).with(
          "posts/1", {"force" => false}
        ).and_return true

        expect(client.delete_post(1, force: false)).to eq true
      end

      it "deletes a post with force" do
        expect(connection).to receive(:delete).with(
          "posts/1", {"force" => true}
        ).and_return true

        expect(client.delete_post(1, force: true)).to eq true
      end
    end

    describe "categories" do
      it "can be listed" do
        expect(connection).to receive(:get_multiple).with(
          Category, "categories", hash_including(page: 1, per_page: 10)
        )
        client.categories

        expect(connection).to receive(:get_multiple).with(
          Category, "categories", hash_including(page: 2, per_page: 60)
        )
        client.categories(page: 2, per_page: 60)
      end

      it "can be found" do
        category = instance_double(Category)

        expect(connection).to receive(:get).with(
          Category, "categories/12"
        ).and_return category

        expect(client.find_category(12)).to eq category
      end

      it "can be created" do
        category = instance_double(Category)

        expect(connection).to receive(:create).with(
          Category, "categories", name: "Foo"
        ).and_return category

        expect(client.create_category(name: "Foo")).to eq category
      end

      it "can be updated" do
        category = instance_double(Category)

        expect(connection).to receive(:put).with(
          Category, "categories/45", name: "New"
        ).and_return category

        expect(client.update_category(45, name: "New")).to eq category
      end
    end

    describe "tags" do
      it "can be listed" do
        expect(connection).to receive(:get_multiple).with(
          Tag, "tags", hash_including(page: 1, per_page: 10)
        )
        client.tags

        expect(connection).to receive(:get_multiple).with(
          Tag, "tags", hash_including(page: 2, per_page: 60)
        )
        client.tags(page: 2, per_page: 60)
      end

      it "can be found" do
        tag = instance_double(Tag)

        expect(connection).to receive(:get).with(
          Tag, "tags/12"
        ).and_return tag

        expect(client.find_tag(12)).to eq tag
      end

      it "can be created" do
        tag = instance_double(Tag)

        expect(connection).to receive(:create).with(
          Tag, "tags", name: "Foo"
        ).and_return tag

        expect(client.create_tag(name: "Foo")).to eq tag
      end

      it "can be updated" do
        tag = instance_double(Tag)

        expect(connection).to receive(:put).with(
          Tag, "tags/45", name: "New"
        ).and_return tag

        expect(client.update_tag(45, name: "New")).to eq tag
      end
    end

    describe "media" do
      it "can be uploaded from IO objects" do
        media = instance_double(Media)
        io = double("io")

        expect(connection).to receive(:upload).with(
          Media, "media", io, mime_type: "text/plain", filename: "foo.txt"
        ).and_return media

        expect(client.upload(io, mime_type: "text/plain", filename: "foo.txt")).to eq media
      end

      it "can be uploaded from files" do
        media = instance_double(Media)

        Dir.mktmpdir do |dir|
          file = File.join(dir, "test.txt")
          File.write(file, "hello world")

          expect(connection).to receive(:upload) do |_, _, io, filename:, mime_type:|
            expect(filename).to eq "test.txt"
            expect(mime_type).to eq "text/plain"

            expect(io.read).to eq "hello world"
            media
          end

          expect(client.upload_file(file, mime_type: "text/plain")).to eq media
        end
      end

      it "can be found" do
        media = instance_double(Media)

        expect(connection).to receive(:get).with(Media, "media/7").and_return(media)

        expect(client.find_media(7)).to eq media
      end

      it "can be listed" do
        media = instance_double(Media)

        expect(connection).to receive(:get_multiple).with(
          Media, "media", per_page: 10, page: 1
        ).and_return([media])

        expect(client.media).to eq [media]
      end

      it "can be updated" do
        media = instance_double(Media)

        expect(connection).to receive(:put).with(
          Media, "media/7", title: "New"
        ).and_return(media)

        expect(client.update_media(7, title: "New")).to eq media
      end
    end

    describe "comments" do
      it "can be found" do
        expect(connection).to receive(:get_multiple).with(
          Comment, "comments", hash_including(page: 2, per_page: 13, post: 4)
        ).and_return []

        expect(client.comments(per_page: 13, page: 2, post: 4)).to eq []
      end
      
      it "can be created" do
        comment = instance_double(Comment, id: 3)
        attributes = { content: "Foo" }

        expect(connection).to receive(:create).with(
          Comment, "comments", attributes
        ).and_return comment

        # We don't expect here as the `create` call below could be enough, but
        # it's also very possible that we need to fetch the post again after
        # doing other things to it.
        allow(connection).to receive(:get).with(
          Comment, "comments/3"
        ).and_return(comment)

        expect(client.create_comment(attributes)).to eq comment
      end
    end
  end
end
