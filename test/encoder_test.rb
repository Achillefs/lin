require 'helper'

describe Lin::Encoder do
  it "returns lin string" do
    assert_equal source, encoder.to_s
  end
end