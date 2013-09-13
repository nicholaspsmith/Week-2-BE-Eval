module Tennis
  class Game
    attr_accessor :player1, :player2

    def initialize
      @player1 = Player.new
      @player2 = Player.new
      @player1.opponent = @player2
      @player2.opponent = @player1
    end

    # A point is scored by a player
    #
    # player - the player who has the point (1 or 2)
    #
    # Returns nothing
    def wins_ball(player)
      if player == 1
        @player1.record_won_ball!
        won_game(@player1)
      elsif player == 2
        @player2.record_won_ball!
        won_game(@player2)
      end

      reset_statuses

      determine_score
    end

    # Sets deuce and advantage to false for both players
    # to prepare for running determine_score method
    def reset_statuses
      @player1.deuce = false
      @player2.deuce = false
      @player1.advantage = false
      @player2.advantage = false
    end

    # Determines if a 'deuce' or 'advantage' has occurred
    def determine_score
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

    # Determine if the player has won the game
    # if so, it increments variable games_won
    #
    # player - the player who has scored the point
    #
    # Returns nothing
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

    # Determine if the player has won the set
    # if so, increments variable sets_won
    #
    # player - the player who has scored the point
    #
    # Returns nothing
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

    # Determines if player has won the match
    # 
    # player - the player who has scored the point
    def won_match(player)
      if player.sets_won > 1 and player.opponent.sets_won < 1
        player.matches_won += 1
        start_new_match
      end
    end

    # Reset players scores back to zero to prepare for 
    # new game
    def reset_scores
      @player1.points = 0
      @player2.points = 0
    end

    # Reset all stats for both players other than matches_won
    # to prepare for new match
    def start_new_match
      @player1.points = 0
      @player1.deuce = false
      @player1.advantage = false
      @player1.win = false
      @player1.games_won = 0
      @player1.sets_won = 0

      @player2.points = 0
      @player2.deuce = false
      @player2.advantage = false
      @player2.win = false
      @player2.games_won = 0
      @player2.sets_won = 0
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