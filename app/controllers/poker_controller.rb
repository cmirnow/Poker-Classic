class PokerController < ApplicationController
  def index
    card = Poker.get_cards(params[:array_card1], params[:array_card2])
    @total1 = Poker.first_player_cards(card, params[:keepit1])
    @total2 = Poker.second_player_cards(card, params[:keepit2])

    if (params[:secondroll] == '0') || params[:secondroll].nil?
      @ind_doubl = Poker.precount(@total1)
      @cash = Poker.get_cash(params[:cash])
    else
      showdown_or_fold?(params[:yesno], params[:cash], @total1, @total2)
    end
  end

  def showdown_or_fold?(*args)
    if args[0] == 'showdown'
      arr = Poker.calculations(args[2], args[3])
      flash_poker_hands(arr[2], arr[3])
      flash_result_of_bet(arr[0], arr[1])
      @cash = Poker.cash(arr[0], args[1])
    elsif args[0] == 'fold'
      flash_if_fold
      @cash = Poker.cash_if_fold(args[1])
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
