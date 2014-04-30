require "helper"

describe Lin::Parser do
  it "returns s player" do
    assert_equal "skrzat", parser.s_name
  end

  it "returns w player" do
    assert_equal "morgoth85", parser.w_name
  end

  it "returns n player" do
    assert_equal "piotr59", parser.n_name
  end

  it "returns e player" do
    assert_equal "253", parser.e_name
  end

  it "returns board name" do
    assert_equal "Board 13", parser.board_name
  end

  it "returns bids" do
    expected = ["p", "b two club", "p", "b three heart", "p", "b four club", "p", "b four heart", "p", "b four spade", "p", "b five club", "p", "b five diamond", "p", "b five heart", "p", "b five spade", "p", "b five no_trump", "p", "b six diamond", "d", "b seven heart", "p", "p", "p"]
    assert_equal expected, parser.bids
  end

  it "returns alerted bids" do
    expected = ["b three diamond", "p", "b three heart", "d", "b three spade", "b four heart", "p", "b five heart", "p", "p", "p"]
    assert_equal expected, Lin::Parser.new(alerted_auction_source).bids
  end

  it "returns cards" do
    expected = ["KD", "AD", "4D", "9D", "6D", "5D", "9H", "3D", "KH", "7H", "4C", "AH", "8H"]
    assert_equal expected, parser.cards
  end

  it "returns claim" do
    assert_equal 12, parser.claim
  end

  it "returns no claim" do
    assert_nil Lin::Parser.new(alerted_auction_source).claim
  end

  it "returns vulnerable" do
    assert_equal :all, parser.vulnerable
  end

  it "returns s hand" do
    assert_equal ["2S", "5S", "7S", "9S", "3H", "8H", "AH", "4D", "5D", "8D", "QD", "2C", "6C"], parser.s
  end

  it "returns w hand" do
    assert_equal ["4S", "2H", "4H", "5H", "6H", "9H", "10H", "JH", "QH", "KH", "9D", "JC", "KC"], parser.w
  end

  it "returns n hand" do
    assert_equal ["3S", "6S", "10S", "QS", "7H", "2D", "3D", "10D", "KD", "3C", "7C", "9C", "QC"], parser.n
  end

  it "returns e hand" do
    assert_equal ["AS", "KS", "JS", "8S", "AD", "JD", "7D", "6D", "AC", "10C", "8C", "5C", "4C"], parser.e
  end

  it "returns dealer" do
    assert_equal :north, parser.dealer
  end
  
  it "returns data hash" do
    assert_equal data, parser.to_hash
  end
end
