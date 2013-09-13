module Tennis
  class Game
    attr_accessor :player1, :player2

    def initialize
      @player1 = Player.new
      @player2 = Player.new
      @player1.opponent = @player2
      @player2.opponent = @player1
    end


    def wins_ball(num)
      if num == 1
        @player1.record_won_ball!
        won_game(@player1)
      elsif num == 2
        @player2.record_won_ball!
        won_game(@player2)
      end

      reset_statuses

      point1 = @player1.points
      point2 = @player2.points

      if point1 > 2 and point2 > 2
        if point1 == point2
          @player1.deuce = true
          @player2.deuce = true
        elsif point1 > point2
          @player1.advantage = true
        elsif point2 > point1
          @player2.advantage = true
        end
      end
    end

    def won_game(player)
      if player.advantage
        player.win = true
        player.games_won += 1
        won_set(player)
        reset_scores
      elsif player.points > 3 and player.opponent.points < 3
        player.win = true
        player.games_won += 1
        won_set(player)
        reset_scores
      end
    end

    def won_set(player)
      if player.games_won >= 6 and player.opponent.games_won < 5
        player.sets_won += 1
        @player1.games_won = 0
        @player2.games_won = 0
        won_match(player)
      elsif player.games_won == 7
        player.sets_won += 1
        @player1.games_won = 0
        @player2.games_won = 0
        won_match(player)
      end
    end

    def won_match(player)
      if player.sets_won > 1 and player.opponent.sets_won < 1
        player.matches_won += 1
        start_new_match
      end
    end

    def reset_statuses
      @player1.deuce = false
      @player2.deuce = false
      @player1.advantage = false
      @player2.advantage = false
    end

    def reset_scores
      @player1.points = 0
      @player2.points = 0
    end

    def start_new_match
      @person1.points = 0
      @person1.@deuce = false
      @person1.@advantage = false
      @person1.@win = false
      @person1.@games_won = 0
      @person1.@sets_won = 0

      @person2.points = 0
      @person2.@deuce = false
      @person2.@advantage = false
      @person2.@win = false
      @person2.@games_won = 0
      @person2.@sets_won = 0
    end

  end

  class Player
    attr_accessor :points, :opponent, :deuce, :advantage, :win, :games_won, :sets_won, :matches_won

    def initialize
      @points = 0
      @score = ['love','fifteen','thirty','forty']
      @deuce = false
      @advantage = false
      @win = false
      @games_won = 0
      @sets_won = 0
      @matches_won = 0
    end

    # Increments the score by 1.
    #
    # Returns the integer new score.
    def record_won_ball!
      @points += 1
    end

    # Returns the String score for the player.
    def score
      if (@deuce == false && @advantage == false)
        @score[@points]
      elsif @deuce
        'deuce'
      elsif @advantage
        'advantage'
      end
        
    end
  end
end