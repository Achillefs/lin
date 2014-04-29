require "strscan"

module Lin
  class Parser
    attr_reader :source

    def initialize(source)
      @source = source
    end

    # Returns cards for S hand
    #
    # @return [Array<String>]
    def s
      @s ||= parse_hand(parsed["md"][0].split(",")[0][1..-1])
    end

    # Returns cards for W hand
    #
    # @return [Array<String>]
    def w
      @w ||= parse_hand(parsed["md"][0].split(",")[1])
    end

    # Returns cards for N hand
    #
    # @return [Array<String>]
    def n
      @n ||= parse_hand(parsed["md"][0].split(",")[2])
    end

    # Returns cards for E hand
    #
    # @return [Array<String>]
    def e
      @e ||= deck - s - w - n
    end

    # Returns S player name
    #
    # @return [String]
    def s_name
      @s_name ||= players[0]
    end

    # Returns W player name
    #
    # @return [String]
    def w_name
      @w_name ||= players[1]
    end

    # Returns N player name
    #
    # @return [String]
    def n_name
      @n_name ||= players[2]
    end

    # Returns E player name
    #
    # @return [String]
    def e_name
      @e_name ||= players[3]
    end

    # Returns board name
    #
    # @return [String]
    def board_name
      @board_name ||= parsed["ah"][0]
    end

    # Returns dealer
    #
    # @return [:north, :east, :south, :west]
    def dealer
      @dealer ||= case parsed["md"][0][0]
      when "1" then :south
      when "2" then :west
      when "3" then :north
      when "4" then :east
      end
    end

    # Returns bids
    #
    # @return [Array<String>]
    def bids
      @bids ||= parsed["mb"].map do |bid|
        case bid.upcase
        when "P" then "p"
        when "D" then "d"
        when "R" then "r"
        when /\dN/ then "b #{Level.name(bid[0].to_i)} no trump"
        when /\dS/ then "b #{Level.name(bid[0].to_i)} spade"
        when /\dH/ then "b #{Level.name(bid[0].to_i)} heart"
        when /\dD/ then "b #{Level.name(bid[0].to_i)} diamond"
        when /\dC/ then "b #{Level.name(bid[0].to_i)} club"
        end
      end
    end

    # Returns played cards
    #
    # @return [Array<String>]
    def cards
      @cards ||= parsed["pc"].map(&:reverse)
    end

    # Returns claimed number of tricks
    #
    # @return [Integer, nil]
    def claim
      @claim ||= parsed["mc"][0] && parsed["mc"][0].to_i
    end

    # Returns vulnerable
    #
    # @return ["NONE" "NS", "EW", "BOTH"]
    def vulnerable
      @vulnerable ||= case parsed["sv"][0]
      when "n" then :north_south
      when "e" then :east_west
      when "b" then :all
      else
        :none
      end
    end

    private

    def players
      @players ||= parsed["pn"][0].split(",")
    end

    def parsed
      return @parsed if defined?(@parsed)
      scanner = StringScanner.new(source)
      @parsed = Hash.new { |hash, key| hash[key] = [] }
      until scanner.eos?
        scanner.scan_until(/[\w]{2}\|[^\|]*\|/)
        key, value = retrieve_pair(scanner.matched)
        @parsed[key] << value
      end
      @parsed
    end

    # "md|some value here|", "md||"
    def retrieve_pair(source)
      result = source.split("|")
      [result[0], result[1]]
    end

    def parse_hand(hand)
      (hand.match(/S(.*?)H/)[1].split("").map { |value| value.upcase << "S" } <<
      hand.match(/H(.*?)D/)[1].split("").map { |value| value.upcase << "H" } <<
      hand.match(/D(.*?)C/)[1].split("").map { |value| value.upcase << "D" } <<
      hand.match(/C(.*?)$/)[1].split("").map { |value| value.upcase << "C" }).flatten
    end

    def deck
      ["AS", "KS", "QS", "JS", "TS", "9S", "8S", "7S", "6S", "5S", "4S", "3S", "2S", "AH", "KH", "QH", "JH", "TH", "9H", "8H", "7H", "6H", "5H", "4H", "3H", "2H", "AD", "KD", "QD", "JD", "TD", "9D", "8D", "7D", "6D", "5D", "4D", "3D", "2D", "AC", "KC", "QC", "JC", "TC", "9C", "8C", "7C", "6C", "5C", "4C", "3C", "2C"]
    end
  end
end
