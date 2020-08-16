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
        arr = Poker.calculations(@total1, @total2)
        flash_poker_hands(arr[2], arr[3])
        flash_result_of_bet(arr[0], arr[1])
        @cash = Poker.cash(arr[0], params[:cash])
      elsif params[:yesno] == 'fold'
        flash_if_fold
        @cash = Poker.cash_if_fold(params[:cash])
      end
    end
  end

  def flash_result_of_bet(result, bet_result)
    if result.odd?
      flash.now[:error] = bet_result
    else
      flash.now[:success] = bet_result
    end
  end

  def flash_if_fold
    flash.now[:error] = 'Fold. You bet $20.'
  end

  def flash_poker_hands(i1, i2)
    flash.now[:notice] = 'Casino: ' + Poker::HANDS[i1]
    flash.now[:warning] = 'You: ' + Poker::HANDS[i2]
  end
end
