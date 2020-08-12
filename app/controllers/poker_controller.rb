class PokerController < ApplicationController
  def index
    card = []
    while card.length < 10
      d = CardComparable.new
      if params[:array_card1].present?
        unless params[:array_card1].include?("#{d.suit},#{d.value}")
          card << d unless params[:array_card2].include?("#{d.suit},#{d.value}")
      end
      else
        card << d
      end
      card = card.uniq
    end

    card1 = card[0..4]
    @total1 = []
    card1.each_with_index do |line, index|
      @total1 << if params[:keepit1].present? && params[:keepit1][index.to_s].present?
                   params[:keepit1][index.to_s]
                 else
                   "#{line.suit},#{line.value}"
    end
    end

    card2 = card[5..9]
    @total2 = []
    card2.each_with_index do |line, index|
      @total2 << if params[:keepit2].present? && params[:keepit2][index.to_s].present?
                   params[:keepit2][index.to_s]
                 else
                   "#{line.suit},#{line.value}"
    end
    end

    if (params[:secondroll] == '0') || params[:secondroll].nil?
      @ind_doubl = Poker.precount(@total1)
      @cash = if params[:cash].nil?
                100
              else
                params[:cash]
              end
    end

    if params[:secondroll] == '1'
      if params[:yesno] == 'showdown'
        int1 = Poker.counter(@total1)
        int2 = Poker.counter(@total2)
        poker_hands = [
          'Nothing',
          'One Pair',
          'Two Pair!',
          'Three Of A Kind!',
          'Straight!',
          'Flush!',
          'Full House!',
          'Four Of A Kind!',
          'Straight Flush!',
          'Royal Flush!'
        ]
        flash.now[:notice] = 'Casino: ' + poker_hands[int1]
        flash.now[:warning] = 'You: ' + poker_hands[int2]
        result = Poker.postcount(@total1, @total2, int1, int2)
        bet_result = [
          'You won this bet.',
          'You lost this bet.',
          'High card! You won this bet.',
          'High card! You lost this bet.',
          'Kicker! You won this bet.',
          'Kicker! You lost this bet.',
          'Split the pot.'
        ][result]

        if result.odd?
          flash.now[:error] = bet_result
          @cash = params[:cash].to_i - 40
        else
          flash.now[:success] = bet_result
          @cash = params[:cash].to_i + 40
        end
      elsif params[:yesno] == 'fold'
        flash.now[:error] = 'Fold. You bet $20.'
        @cash = params[:cash].to_i - 20
      end
    end
  end
end
