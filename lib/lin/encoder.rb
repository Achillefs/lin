=begin rdoc
  Here is a list of link sections headers:
    pn => player names
    st => unknown
    md => <dealer><south's hand>,<west's hand>,<north's hand>,<<east's hand (may be missing)>>
    rh => unknown
    ah => board
    sv => vulnerability
    mb => bids
    pc => played cards
    mc => claim
=end
module Lin
  class Encoder
    attr_reader :source

    def initialize(source)
      @source = source
    end
    
    def to_s
      return @string unless @string.nil?
      @string = 'pn|'
      # player names
      @string<< [Lin::DIRECTIONS.map { |d| source[:players][d] }].join(',')
      # an unknown var and hands heading
      @string<< '|st||md|'
      # dealer
      @string<< (Lin::DIRECTIONS.index(source[:dealer]).to_i + 1).to_s
      # hands
      @string<< transform_hands
      # an unknown var, board heading and board
      @string<< "|rh||ah|Board #{source[:board]}"
      @string<< "|sv|#{Lin::VULNERABILITY.key(source[:vulnerability])}|"
      @string<< "#{formatted_bids}|"
      @string<< "#{formatted_cards}|"
      @string<< "mc|"
      @string<< source[:claim].to_s unless source[:claim].nil?
      @string<< "|"
    end
    
    def hands(opts = {})
      transform_hands(opts)
    end
    
    def dealer
      source[:dealer].to_s[0]
    end
    
    # grab the last bid, 
    def trump_suit
      bids = source[:bids].reject { |b| %W[p pass d double r redouble].include? b }
      bids.last.split(' ').last[0]
    end
    
    def played_cards
      source[:played].map { |c| c.reverse }.join(' ')
    end
    
    def to_bcalc
      %{./bcalconsole -c #{transform_hands(full:true)} -d lin -l #{dealer} -t #{trump_suit} -e '#{played_cards} e' -q}
    end
    
    private
    def transform_hands opts = {}
      if opts[:full]
        %W[south west north east].map { |d| transform_hand(d.to_sym) }.join(',')
      else
        %W[south west north].map { |d| transform_hand(d.to_sym) }.join(',') + ','
      end
    end
    
    # return string representation of a hand
    # order: S H D C
    def transform_hand direction
      string = ''
      hand = source[:hands][direction]
      %W{ S H D C }.map do |strain|
        cards = hand.select { |c| c =~ %r{.*#{strain}$} }
        string<< "#{strain}#{cards.map { |c| c.gsub('10','T').gsub(strain,'') }.join('')}"
      end
      string
    end
    
    def formatted_bids
      source[:bids].map { |bid| 
        level = bid.split(' ')[1].to_sym if bid =~ /^b/i
        case bid
        when /b ([a-z]{3,5}) no_trump/i then "mb|#{Level.send(level)}N"
        when /b ([a-z]{3,5}) spade/i then "mb|#{Level.send(level)}S"
        when /b ([a-z]{3,5}) heart/i then "mb|#{Level.send(level)}H"
        when /b [a-z]{3,5} diamond/i then "mb|#{Level.send(level)}D"
        when /b [a-z]{3,5} club/i then "mb|#{Level.send(level)}C"
        else 
          "mb|#{bid}"
        end
      }.join('|')
    end
    
    def formatted_cards
      source[:played].map { |c| 
        "pc|#{c.reverse}"
      }.join('|')
    end
  end
end