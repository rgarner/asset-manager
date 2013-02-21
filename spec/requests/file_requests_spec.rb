require "spec_helper"

describe "File requests" do
  before(:each) do
    login_as_stub_user
  end

  describe "requesting an asset that doesn't exist" do
    it "should respond with file not found" do
      get "/files/34/test.jpg"
      response.status.should == 404
    end
  end

  describe "request an asset that does exist" do
    before(:each) do
      @asset = FactoryGirl.create(:asset)

      get "/files/#{@asset.id}/asset.png", nil, {
        "HTTP_X_SENDFILE_TYPE" => "X-Accel-Redirect",
        "HTTP_X_ACCEL_MAPPING" => "/var/govuk/asset-manager/spec/support/uploads/asset/=/media/"
      }
    end

    it "should set the X-Accel-Redirect header" do
      response.should be_success
      response.headers["X-Accel-Redirect"].should == "/media/#{@asset.id}/#{@asset.file.identifier}"
    end
  end
end
