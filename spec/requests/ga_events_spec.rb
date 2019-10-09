vcr_option = {
  cassette_name: "ga_event",
  allow_playback_repeats: "true"
}

describe "GaEvents", type: :request, vcr: vcr_option do
  describe "POST /fallback_activity_recorder" do
    it "posts to fallback_activity_recorder" do
      post "/fallback_activity_recorder", params: {
        path: "/ben", user_language: "en"
      }.to_json
      expect(response.body).to eq("")
    end
  end
end
