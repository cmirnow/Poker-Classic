class PokerController < ApplicationController
  def index
    cards = Poker.get_cards(params[:array_card1], params[:array_card2])
    @cards1 = Poker.first_player_cards(cards, params[:keepit1])
    @cards2 = Poker.second_player_cards(cards, params[:keepit2])

    if (params[:secondroll] == '0') || params[:secondroll].nil?
      @first_hand_combination = Poker.precount(@cards1)
      @cash = Poker.get_cash(params[:cash])
    else
      showdown_or_fold?(params[:yesno], params[:cash], @cards1, @cards2)
    end
  end

  def showdown_or_fold?(*args)
    if args[0] == 'showdown'
      arr = Poker.calculations(args[2], args[3])
      flash_result_of_bet(arr[0], arr[1], arr[2], arr[3])
      @cash = Poker.cash_to_win_or_lose?(arr[0], args[1])
    elsif args[0] == 'fold'
      flash_if_fold
      @cash = Poker.cash_if_fold(args[1])
    end
  end

  def flash_result_of_bet(*args)
    flash.now[:notice] = 'Casino: ' + Poker::HANDS[args[2]]
    flash.now[:warning] = 'You: ' + Poker::HANDS[args[3]]
    if args[0].odd?
      flash.now[:error] = args[1]
    else
      flash.now[:success] = args[1]
    end
  end

  def flash_if_fold
    flash.now[:error] = 'Fold. You bet $20.'
  end
end
