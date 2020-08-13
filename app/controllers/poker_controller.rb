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
        flash_messages(arr[2], arr[3])
        @cash = cash(arr[0], arr[1], params[:cash])
      elsif params[:yesno] == 'fold'
        @cash = cash_if_fold(params[:cash])
      end
    end
  end

  def cash(result, bet_result, params_cash)
    if result.odd?
      flash.now[:error] = bet_result
      params_cash.to_i - 40
    else
      flash.now[:success] = bet_result
      params_cash.to_i + 40
    end
  end

  def cash_if_fold(params_cash)
    flash_if_fold
    params_cash.to_i - 20
  end

  def flash_if_fold
    flash.now[:error] = 'Fold. You bet $20.'
  end

  def flash_messages(int1, int2)
    flash.now[:notice] = 'Casino: ' + Poker::HANDS[int1]
    flash.now[:warning] = 'You: ' + Poker::HANDS[int2]
  end
end
