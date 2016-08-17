require "web"

require "rack/test"

require "ipaddr"

RSpec.describe Web do
  include Rack::Test::Methods

  def app
    @app ||= Web.new
  end

  describe "GET /" do
    let(:home_page) {
      get "/"
      last_response.body
    }

    it "app instance index" do
      expect(home_page).to match( /Hi, I'm app instance \d+/)
    end

    it "running at" do
      expect(home_page).to include("at example.org:80")
    end

    it "total instance responses" do
      expect(home_page).to match(/\d+ times through this app instance/)
    end

    it "total app responses" do
      expect(home_page).to match(/\d+ times in total/)
    end
  end

  describe "POST /app_supporters" do
    let(:app_supporter) {
      ->(name) {
        post "/app_supporters", name: name
        expect(last_response).to be_redirect
      }
    }

    let(:home_page) {
      ENV.store("SHOW_APP_SUPPORTERS", "true")
      get "/"
      last_response.body
    }

    it "stores name" do
      app_supporter.("Simon")
      expect(home_page).to match(/Simon/)
    end

    it "stores name only once" do
      app_supporter.("Simon")
      app_supporter.("Simon")
      expect(home_page.scan("Simon").size).to eq(1)
    end
  end
end
