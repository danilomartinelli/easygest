require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = described_class.new
    user.email = "test@example.com"
    expect(user).to be_valid
  end

  it "is not valid without a valid a email" do
    user = described_class.new
    user.email = "test.example"
    expect(user).to be_invalid
  end

  it "email is downcase" do
    user = described_class.new
    user.email = "TEST@EXAMPLE.COM"
    user.save
    expect(user.email).to eq "test@example.com"
  end
end
