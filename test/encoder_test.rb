require 'helper'

describe Lin::Encoder do
  it "returns lin string" do
    assert_equal source, encoder.to_s
  end
  
  it 'returns trump suit' do
    assert_equal 'h', encoder.trump_suit
  end
  
  it 'returns hands string' do
    assert_equal 'S2579H38AD458QC26,S4H24569TJQKD9CJK,S36TQH7D23TKC379Q,', encoder.hands
  end
  
  it 'returns full hands string' do
    assert_equal 'S2579H38AD458QC26,S4H24569TJQKD9CJK,S36TQH7D23TKC379Q,SAKJ8HDAJ76CAT854', encoder.hands(full: true)
  end
  
  it 'returns leader' do
    assert_equal 'n', encoder.dealer
  end
  
  it 'can generate bcalc command' do
    cmd = %{./bcalconsole -c S2579H38AD458QC26,S4H24569TJQKD9CJK,S36TQH7D23TKC379Q,SAKJ8HDAJ76CAT854 -d lin -l n -t h -e 'DK DA D4 D9 D6 D5 H9 D3 HK H7 C4 HA H8 e' -q}
    assert_equal cmd, encoder.to_bcalc
  end
end