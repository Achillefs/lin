require 'lin/version'
require 'lin/parser'
require 'lin/encoder'
require 'bridge'
module Lin
  HEADINGS = {
    pn: :player_names,
    st: :unknown,
    md: :hands,
    rh: :unknown,
    ah: :board,
    sv: :vulnerability,
    mb: :bids,
    pc: :cards_played,
    mc: :claim
  }.freeze
  
  DIRECTIONS = [:south, :west, :north, :east].freeze
  VULNERABILITY = {
    n: :north_south,
    e: :east_west,
    b: :all
  }.freeze
  
  # returns structured data from lin
  def self.parse(data)
    Lin::Parser.new(data).to_hash
  end
  
  # returns a lin-formatted string
  def self.encode(data)
    Lin::Encoder.new(data).to_s
  end
end
