require "helper"

describe Lin::Parser do
  def source
    "pn|skrzat,morgoth85,piotr59,253|st||md|3S2579H38AD458QC26,S4H24569TJQKD9CJK,S36TQH7D23TKC379Q,|rh||ah|Board 13|sv|b|mb|p|mb|1C|mb|p|mb|2H|mb|p|mb|3C|mb|p|mb|3H|mb|p|mb|3S|mb|p|mb|4C|mb|p|mb|4D|mb|p|mb|4H|mb|p|mb|4S|mb|p|mb|4N|mb|p|mb|5D|mb|d|mb|6H|mb|p|mb|p|mb|p|pc|DK|pc|DA|pc|D4|pc|D9|pc|D6|pc|D5|pc|H9|pc|D3|pc|HK|pc|H7|pc|C4|pc|HA|pc|H8|mc|12|"
  end

  def alerted_auction_source
    "pn|stanwest,morgoth85,bronek2,253|st||md|3S59H345QKD248C579,S24QH7JAD7TJKACQA,S68TJKH6D9QC236TJ,|rh||ah|Board 13|sv|b|mb|2D|an|wilk|mb|p|mb|2H|mb|d|mb|2S|mb|3H|mb|p|mb|4H|mb|p|mb|p|mb|p|pg||pc|S5|pc|S2|pc|ST|pc|S7|pg||pc|S6|pc|S3|pc|S9|pc|SQ|pg||pc|HA|pc|H6|pc|H2|pc|H3|pg||pc|HJ|pc|C2|pc|H8|pc|HQ|pg||pc|C7|pc|CQ|pc|C3|pc|C4|pg||pc|S4|pc|SJ|pc|SA|pc|H4|pg||pc|D4|pc|DK|pc|D9|pc|D5|pg||pc|CA|pc|C6|pc|C8|pc|C5|pg||pc|H7|pc|S8|pc|H9|pc|HK|pg||pc|D2|pc|DT|pc|DQ|pc|D3|pg||pc|SK|pc|HT|pc|D8|pc|D7|pg||pc|CK|pc|C9|pc|DJ|pc|CT|pg||pc|D6|pc|H5|pc|DA|pc|CJ|pg||"
  end

  it "returns s player" do
    assert_equal "skrzat", Lin::Parser.new(source).s_name
  end

  it "returns w player" do
    assert_equal "morgoth85", Lin::Parser.new(source).w_name
  end

  it "returns n player" do
    assert_equal "piotr59", Lin::Parser.new(source).n_name
  end

  it "returns e player" do
    assert_equal "253", Lin::Parser.new(source).e_name
  end

  it "returns board name" do
    assert_equal "Board 13", Lin::Parser.new(source).board_name
  end

  it "returns bids" do
    expected = ["p", "b two club", "p", "b three heart", "p", "b four club", "p", "b four heart", "p", "b four spade", "p", "b five club", "p", "b five diamond", "p", "b five heart", "p", "b five spade", "p", "b five no trump", "p", "b six diamond", "d", "b seven heart", "p", "p", "p"]
    assert_equal expected, Lin::Parser.new(source).bids
  end

  it "returns alerted bids" do
    expected = ["b three diamond", "p", "b three heart", "d", "b three spade", "b four heart", "p", "b five heart", "p", "p", "p"]
    assert_equal expected, Lin::Parser.new(alerted_auction_source).bids
  end

  it "returns cards" do
    expected = ["KD", "AD", "4D", "9D", "6D", "5D", "9H", "3D", "KH", "7H", "4C", "AH", "8H"]
    assert_equal expected, Lin::Parser.new(source).cards
  end

  it "returns claim" do
    assert_equal 12, Lin::Parser.new(source).claim
  end

  it "returns no claim" do
    assert_nil Lin::Parser.new(alerted_auction_source).claim
  end

  it "returns vulnerable" do
    assert_equal :all, Lin::Parser.new(source).vulnerable
  end

  it "returns s hand" do
    assert_equal ["2S", "5S", "7S", "9S", "3H", "8H", "AH", "4D", "5D", "8D", "QD", "2C", "6C"], Lin::Parser.new(source).s
  end

  it "returns w hand" do
    assert_equal ["4S", "2H", "4H", "5H", "6H", "9H", "TH", "JH", "QH", "KH", "9D", "JC", "KC"], Lin::Parser.new(source).w
  end

  it "returns n hand" do
    assert_equal ["3S", "6S", "TS", "QS", "7H", "2D", "3D", "TD", "KD", "3C", "7C", "9C", "QC"], Lin::Parser.new(source).n
  end

  it "returns e hand" do
    assert_equal ["AS", "KS", "JS", "8S", "AD", "JD", "7D", "6D", "AC", "TC", "8C", "5C", "4C"], Lin::Parser.new(source).e
  end

  it "returns dealer" do
    assert_equal :north, Lin::Parser.new(source).dealer
  end
end
