class Poker

    TOTAL_BET = [
      'You won this bet.',
      'You lost this bet.',
      'High card! You won this bet.',
      'High card! You lost this bet.',
      'Kicker! You won this bet.',
      'Kicker! You lost this bet.',
      'Split the pot.'
    ]


    HANDS = [
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

  def self.calculations(total1, total2)
    int1 = Poker.counter(total1)
    int2 = Poker.counter(total2)
    result = Poker.postcount(total1, total2, int1, int2)
    bet_result = TOTAL_BET[result]
    [result, bet_result, int1, int2]
  end

  def self.precount(c)
    total_suit1 = []
    total_value1 = []
    c.each do |line1|
      total_suit1 << line1.first
      total_value1 << line1.split(',').last
    end

    ind_doubl = []
    total_value1.each_with_index.group_by { |f, _i| f }.each { |_k, v| v.map!(&:last) }.values.each do |line1|
      if (total_suit1.uniq.count == 1) || (total_value1.map(&:to_i).sort.each_cons(2).all? { |x, y| y == x + 1 } == true) || (total_value1.map(&:to_i).sort == [2, 3, 4, 5, 14])
        ind_doubl = [0, 1, 2, 3, 4]
      elsif line1.count > 1
        ind_doubl << line1
      end
    end
    ind_doubl = ind_doubl.flatten
  end

  def self.counter(t)
    total_suit = []
    total_value = []
    t.each do |line|
      total_suit << line.first
      total_value << line.split(',').last
    end

    total_value = total_value.map(&:to_i)
    numVals = Hash.new(0)
    (2..14).each do |theval|
      (0..4).each do |dienum|
        numVals[theval] += 1 if total_value[dienum] == theval
      end
    end

    total_suit = total_suit.map(&:to_i)
    numSuit = Hash.new(0)
    (1..4).each do |theval|
      (0..4).each do |dienum|
        numSuit[theval] += 1 if total_suit[dienum] == theval
      end
    end

    numVals = Array.new(numVals.values)
    numSuit = Array.new(numSuit.values)

    # 'royal street flash'
    if (numSuit.find_all { |x| numSuit.count(x) == 1 }).include?(5) && total_value.sort == [10, 11, 12, 13, 14]
      int = 9
    # 'street flash'
    elsif (numSuit.find_all { |x| numSuit.count(x) == 1 }).include?(5) && total_value.sort.each_cons(2).all? { |x, y| y == x + 1 } == true
      int = 8
    # 'flash'
    elsif (numSuit.find_all { |x| numSuit.count(x) == 1 }).include?(5)
      int = 5
    # 'two_pairs'
    elsif (numVals.find_all { |x| numVals.count(x) > 1 }).include?(2)
      int = 2
    # 'care'
    elsif (numVals.find_all { |x| numVals.count(x) == 1 }).include?(4)
      int = 7
    # 'fullhouse'
    elsif (numVals.find_all { |x| numVals.count(x) == 1 }).include?(2) && (numVals.find_all { |x| numVals.count(x) == 1 }).include?(3)
      int = 6
    # 'set'
    elsif (numVals.find_all { |x| numVals.count(x) == 1 }).include?(3)
      int = 3
    # 'pair'
    elsif (numVals.find_all { |x| numVals.count(x) == 1 }).include?(2)
      int = 1
    # 'street'
    elsif (total_value.sort.each_cons(2).all? { |x, y| y == x + 1 } == true) || (total_value.sort == [2, 3, 4, 5, 14])
      int = 4
    else
      int = 0
    end
  end

  def self.postcount(total1, total2, int1, int2)
    total_value1 = []
    total_value2 = []
    total1.each do |line|
      total_value1 << line.split(',').last
    end
    total2.each do |line|
      total_value2 << line.split(',').last
    end
    if int1 < int2
      result = 0 # flash[:notice] = 'You won this bet!'
    elsif int1 > int2
      result = 1 # flash[:error] = 'You lost this bet.'
    elsif int1 == int2 && [0, 4, 5, 8, 9].include?(int1)

      arr = []
      total_value1.map(&:to_i).sort.reverse.zip(total_value2.map(&:to_i).sort.reverse).each do |line|
        if line.first < line.last
          arr << 1
        elsif line.first > line.last
          arr << 0
        end
      end
      result = if arr.first == 1
                 2
               elsif arr.first == 0
                 3
               else
                 6
               end
    elsif int1 == int2 && [1, 3, 2, 6, 7].include?(int1)
      def Poker.duplicate_count(array)
        array.each_with_object(Hash.new(0)) do |value, hash|
          hash[value] += 1
        end.each_with_object([]) do |(value, count), result|
          result << value if count > 1
        end
      end

      if Poker.duplicate_count(total_value1.map(&:to_i)).max < Poker.duplicate_count(total_value2.map(&:to_i)).max
        result = 2
      elsif Poker.duplicate_count(total_value1.map(&:to_i)).max > Poker.duplicate_count(total_value2.map(&:to_i)).max
        result = 3
      elsif Poker.duplicate_count(total_value1.map(&:to_i)).min < Poker.duplicate_count(total_value2.map(&:to_i)).min
        result = 2
      elsif Poker.duplicate_count(total_value1.map(&:to_i)).min > Poker.duplicate_count(total_value2.map(&:to_i)).min
        result = 3
      else
        part1 = total_value1.map(&:to_i)
        part2 = total_value2.map(&:to_i)
        full1 = Poker.duplicate_count(total_value1.map(&:to_i))
        full2 = Poker.duplicate_count(total_value2.map(&:to_i))

        arr = []
        a = ((part1 - full1) | (full1 - part1)).sort.reverse
        b = ((part2 - full2) | (full2 - part2)).sort.reverse
        a.zip(b).each do |line|
          if line.first < line.last
            arr << 1
          elsif line.first > line.last
            arr << 0
          end
        end
        result = if arr.first == 1
                   4
                 elsif arr.first == 0
                   5
                 else
                   6
         end
      end
    end
  end
end
